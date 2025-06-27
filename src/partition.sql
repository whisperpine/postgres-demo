-- tags: partition.

CREATE TABLE IF NOT EXISTS events (
    event_id SERIAL,
    event_name TEXT NOT NULL,
    event_timestamp TIMESTAMP
)
PARTITION BY RANGE (event_timestamp);

CREATE TABLE events_2023
PARTITION OF events
FOR VALUES
FROM ('2023-01-01')
TO ('2024-01-01');

CREATE TABLE events_2024
PARTITION OF events
FOR VALUES
FROM ('2024-01-01')
TO ('2025-01-01');

CREATE TABLE events_2025
PARTITION OF events
FOR VALUES
FROM ('2025-01-01')
TO ('2026-01-01');

INSERT INTO events (event_name, event_timestamp)
VALUES
('Tom caught Jerry', '2023-02-17'),
('Jerry fled', '2024-08-02'),
('Tom caught Jerry again', '2025-07-28');

SELECT * FROM events
WHERE event_timestamp < now();
