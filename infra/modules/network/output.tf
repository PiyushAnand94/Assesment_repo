output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_name" {
  description = "Name tag of the VPC"
  value       = aws_vpc.vpc.tags["Name"]
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets in different Availability Zones"
  value       = [aws_subnet.subnet_public.id, aws_subnet.subnet_public_2.id]
}

output "public_subnet_cidr" {
  description = "CIDR blocks of public subnets"
  value       = [aws_subnet.subnet_public.cidr_block, aws_subnet.subnet_public_2.cidr_block]
}

output "private_subnet_ids" {
  description = "IDs of private subnets in different Availability Zones"
  value       = [aws_subnet.subnet_private.id, aws_subnet.subnet_private_2.id]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = [aws_subnet.subnet_private.cidr_block, aws_subnet.subnet_private_2.cidr_block]
}

output "internet_gateway_id" {
  description = "ID of the VPC internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = aws_nat_gateway.nat.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_rt.id
}