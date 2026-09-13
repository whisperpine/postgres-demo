-- Hypothetical scenario:

-- You are designing a new application for Arctic Events, a company that sells
-- tickets for concerts and sporting events.
--
-- The application must:
--
-- - Allow customers to browse events.
-- - Search for events.
-- - Purchase tickets.
-- - Send purchase confirmations.
-- - Allow organizers to see sales.
-- - Provide an API for selected partners.
--
-- Expected usage:
--
-- - Normal traffic: approximately 100 RPS.
-- - Peak traffic during major ticket releases: approximately 5,000 RPS.
-- - Ticket releases are unpredictable but usually last less than two hours.
-- - The company has six software developers.
-- - The application is expected to remain in operation for at least 8 years.

-- =========
-- customers
-- =========

-- Gross estimation: 1M customers.

-- The table of customers.
CREATE TABLE customers (
    -- Internally used in the database.
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    -- Assume that we send notifications (e.g. order confirmation) by email.
    email TEXT NOT NULL UNIQUE
);

-- The customer profile provided by OIDC identity providers in the form of JWT.
CREATE TABLE customer_identities (
    -- Determined by the OIDC identity provider (the "sub" claim of JWT).
    -- Note: In real-world scenarios, "sub" and "iss" work together to identify
    -- a user ("sub" alone doesn't suffice), but let's be simple here.
    jwt_sub TEXT PRIMARY KEY,
    -- The foreign key referencing the id of a customer.
    customer_id UUID NOT NULL REFERENCES customers(id)
);

-- ==========
-- organizers
-- ==========

-- Gross estimation: 100 organizers.

-- The table of organizers.
CREATE TABLE organizers (
    id UUID PRIMARY KEY DEFAULT uuidv7()
);

-- The organizer profile provided by OIDC identity providers in the form of JWT.
CREATE TABLE organizers_identities (
    jwt_sub TEXT PRIMARY KEY, -- the "sub" claim in JWT.
    organizer_id UUID NOT NULL REFERENCES customers(id)
);

-- =================
-- selected partners
-- =================

-- Gross estimation: 20 selected partners.

-- The table of selected partners.
CREATE TABLE partners (
    id UUID PRIMARY KEY DEFAULT uuidv7()
);

-- The table of API keys used by selected partners.
-- Assume that selected partners use API keys to authorize.
CREATE TABLE api_keys (
    -- SHA256 of the api key.
    key_hash CHAR(64) PRIMARY KEY,
    -- The foreign key referencing the id of the partner.
    partner_id UUID NOT NULL REFERENCES partners(id)
);

-- ======
-- events
-- ======

-- Gross estimation: 1K events (ongoing).

-- The table of events (e.g. sports, concerts).
CREATE TABLE arctic_events (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    -- The name is required for customers to search.
    -- It's indexed automatically due to the UNIQUE keyword.
    name TEXT NOT NULL UNIQUE,
    -- The foreign key referencing the id of the organizer of this event.
    organizer_id UUID NOT NULL REFERENCES organizers(id)
);

-- ======
-- orders
-- ======

-- Gross estimation: 1M orders (ongoing).

-- A custom enum type to enumerate all possible status of an order.
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'cancelled');

-- The table of orders to buy tickets.
-- Note: Transactions are required to create orders. For example, we need to
-- create tickets in the transaction and ensure tickets are not over sold. Once
-- every prerequisites complete, create an order at the end of the transaction.
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    customer_id UUID REFERENCES customers(id),
    status ORDER_STATUS NOT NULL DEFAULT 'pending',
    total_cents INTEGER NOT NULL,
    currency CHAR(3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =======
-- tickets
-- =======

-- Gross estimation: 1M tickets (ongoing).

-- The table of ticket releases.
-- Note: ticket releases are only active when the current timestamp is in the
-- range of start_tz and end_tz.
CREATE TABLE ticket_releases (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    -- A ticket release must always belong to an event.
    arctic_event_id UUID NOT NULL REFERENCES arctic_events(id),
    -- The number of tickets that are released.
    max_num INT CHECK (max_num > 0),
    -- This column is essential to prevent over-sold from happening.
    -- During the transaction to create or cancel an order, it must be modified.
    -- It's expected to be the number of tickets which belong to this ticket
    -- release and the order status of which is "pending" or "paid".
    locked_num INT DEFAULT 0 CHECK (max_num >= locked_num AND locked_num >= 0),
    -- The ticket release starts at this timestamp.
    start_tz TIMESTAMPTZ NOT NULL CHECK (start_tz > now()),
    -- The ticket release end at this timestamp.
    end_tz TIMESTAMPTZ NOT NULL CHECK (end_tz > start_tz)
);

-- The table of tickets.
-- Note: It's not necessary to add foreign keys for id of tables like
-- "arctic_events" or "customers", since we can query those data by joining
-- tables. But if denormalization can improve query performance a lot, we can
-- add those foreign keys later on.
CREATE TABLE tickets (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    ticket_release_id UUID NOT NULL REFERENCES ticket_releases(id),
    order_id UUID NOT NULL REFERENCES orders(id)
);
