# Assesment_repo
Assesment solutions

## Local PostgreSQL database

Docker Compose starts a local PostgreSQL database and runs Flyway migrations
to create the `hotel_bookings` and `booking_events` tables, seed 120 bookings
across multiple cities, organizations, and statuses, and add an index for the
example aggregation query.

```sh
docker compose up -d db
docker compose run --rm flyway
```

The database is available at `localhost:5432` with database `hotel_bookings`,
user `hotel_app`, and password `local_dev_password`. Set `POSTGRES_DB`,
`POSTGRES_USER`, `POSTGRES_PASSWORD`, or `POSTGRES_PORT` in the environment
before running Compose to override these local-development defaults.

To apply future migrations, run `docker compose run --rm flyway` again. To
stop the database while retaining its data, run `docker compose down`; to
remove the database and its data volume, run `docker compose down -v`.

### Backup and restore

With the Compose database running, create a timestamped custom-format dump:

```sh
bash scripts/backup.sh
```

Backups are written to `backups/`. Restore one into a new local database
(default name `hotel_bookings_restore`) by passing its path:

```sh
bash scripts/restore.sh backups/hotel_bookings_YYYYMMDDTHHMMSSZ.dump
```

An optional second argument selects another destination database name. Restore
creates the destination and will fail rather than overwrite it if it already
exists. To verify the restore, query the restored database:

```sh
docker compose exec db psql -U hotel_app -d hotel_bookings_restore -c \
  "SELECT COUNT(*) AS bookings, COUNT(DISTINCT org_id) AS organizations, COUNT(DISTINCT city) AS cities FROM hotel_bookings;"
docker compose exec db psql -U hotel_app -d hotel_bookings_restore -c \
  "SELECT COUNT(*) AS booking_events FROM booking_events;"
```

For the included seed data, expect 120 bookings across 5 organizations and 6
cities, plus 40 booking events. A successful restore also requires both
commands to find their tables and complete without errors.

The query index is `idx_hotel_bookings_city_created_at` on
`(city, created_at) INCLUDE (org_id, status, amount)`. `city` is first because
the query filters it by equality, followed by `created_at` for its date range.
The included columns provide the grouping and aggregation values, allowing
PostgreSQL to use an index-only scan when visibility-map state permits, without
enlarging the index's search key.

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

## ECS/Fargate

The ECS module in `infra/modules/ecs` deploys an ECS cluster, Fargate task
definition and service in private subnets. It registers tasks with the existing
ALB target group, creates a task security group that only accepts application
traffic from the ALB security group, and sends container logs to CloudWatch.

Call the module from the environment that manages the existing VPC and ALB.
The ALB module's `name` input controls its exact resource names: with the
default `"app"`, it creates `app-alb`, `app-alb-sg`, and `app-alb-tg`.
Listener and target ports default to 80.

```hcl
module "ecs" {
  source = "../../modules/ecs"

  name                  = "app"
  listener_port         = 80
  target_port           = 80
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  container_image      = var.container_image
  aws_region           = var.aws_region
}
```

The ALB module must expose its security group ID as `alb_security_group_id`
(alongside the target group ARN), and the target group must use `target_type =
"ip"` for Fargate. Set the container image to an image your account can pull,
and set `container_port` if it differs from the ALB target group's port (80 by
default). The private subnets need outbound access to the image registry and
CloudWatch Logs, typically through a NAT gateway or the appropriate VPC
endpoints.

The network module accepts `name`, VPC CIDR, and CIDRs for two public and two
private subnets. It places each subnet pair in different Availability Zones.
Its outputs include the VPC ID/CIDR, subnet IDs/CIDRs, and gateway and
route-table IDs.

## Private PostgreSQL RDS

The network module returns two private subnets in different Availability Zones
for the RDS DB subnet group. The RDS module requires those subnets and the ECS
task security group; the database has no public access and only accepts
PostgreSQL traffic from ECS.

```hcl
module "rds" {
  source = "../../modules/rds"

  name                  = "app"
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  ecs_security_group_id = module.ecs.task_security_group_id
  username              = "appadmin"
}
```

RDS generates the master password and manages it in AWS Secrets Manager. The
secret ARN is available as `module.rds.master_user_secret_arn`; grant the
application task role access to that secret only if the application needs it.
The RDS endpoint is private and available as `module.rds.endpoint`. This module
defaults to a small `db.t3.micro` instance, encrypted storage, seven-day
backups, and deletion protection. For disposable development databases, set
`deletion_protection = false` and `skip_final_snapshot = true` explicitly.

## Separate dev and prod environments

`infra/envs/dev` and `infra/envs/prod` are independent Terraform roots. Each
has its own variable declarations, `.tfvars`, S3 backend configuration, and
state key. Both environments use the same modules but have separate CIDR ranges
and resource names.

| Setting | Dev | Prod |
|---|---:|---:|
| ECS task | 256 CPU / 512 MiB, 1 task | 512 CPU / 1024 MiB, 2 tasks |
| RDS instance | `db.t3.micro`, Single-AZ | `db.t3.small`, Multi-AZ |
| RDS backup retention | 1 day | 30 days |
| RDS deletion protection | Disabled | Enabled |
| Final snapshot on DB deletion | Skipped | Required |

Before initializing either environment:

1. Create an S3 bucket for Terraform state, enable bucket versioning, and
   restrict access to the deployment roles/users.
2. Replace `REPLACE_WITH_YOUR_TERRAFORM_STATE_BUCKET` in that environment's
   `backend.hcl` with the bucket name. Update the backend region if the bucket
   is in a different region.
3. Set `aws_region` and `container_image` in the environment's `.tfvars`.
   Replace the sample Nginx image with your application image before deploying
   the real service, especially in prod.
4. Configure AWS credentials outside Terraform, for example with an AWS CLI
   profile or an assumed role.

Initialize and deploy dev:

```sh
cd infra/envs/dev
terraform init -backend-config=backend.hcl
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Deploy prod separately:

```sh
cd infra/envs/prod
terraform init -backend-config=backend.hcl
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

The backend uses distinct `assessment/dev/terraform.tfstate` and
`assessment/prod/terraform.tfstate` keys and S3 native state locking (Terraform
1.10 or later). The current environment roots create their own VPC, ALB, ECS
service, and RDS instance; if those resources already exist outside these
states, import them or adapt the configuration before applying to avoid
creating duplicates.
