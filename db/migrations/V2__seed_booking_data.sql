INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    md5('hotel-booking-' || booking_number)::uuid,
    md5('organization-' || ((booking_number - 1) % 5))::uuid,
    'hotel-' || lpad((((booking_number - 1) % 12) + 1)::text, 2, '0'),
    (ARRAY['delhi', 'mumbai', 'jaipur', 'goa', 'bengaluru', 'chennai'])
        [((booking_number - 1) % 6) + 1],
    CURRENT_DATE + (booking_number % 90),
    CURRENT_DATE + (booking_number % 90) + ((booking_number % 5) + 1),
    (50 + booking_number * 13.75)::numeric(12, 2),
    (ARRAY['CONFIRMED', 'CANCELLED', 'PENDING', 'COMPLETED'])
        [((booking_number - 1) % 4) + 1],
    CURRENT_TIMESTAMP - ((booking_number % 60) || ' days')::interval
FROM generate_series(1, 120) AS series(booking_number);

INSERT INTO booking_events (booking_id, event_type, payload, created_at)
SELECT
    md5('hotel-booking-' || booking_number)::uuid,
    (ARRAY['BOOKING_CREATED', 'PAYMENT_PROCESSED', 'STATUS_UPDATED'])
        [((booking_number - 1) % 3) + 1],
    jsonb_build_object(
        'source', 'seed',
        'sequence', booking_number,
        'status', (ARRAY['CONFIRMED', 'CANCELLED', 'PENDING', 'COMPLETED'])
            [((booking_number - 1) % 4) + 1]
    ),
    CURRENT_TIMESTAMP - ((booking_number % 60) || ' days')::interval
FROM generate_series(1, 120) AS series(booking_number)
WHERE booking_number % 3 = 0;
