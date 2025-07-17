CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- Then create the 'options' table with a foreign key referencing users(id)
CREATE TABLE options (
    id SERIAL PRIMARY KEY,
    type VARCHAR(20) NOT NULL,  -- e.g., "Call" or "Put"
    spot DOUBLE PRECISION NOT NULL,
    strike DOUBLE PRECISION NOT NULL,
    rate_domestic DOUBLE PRECISION NOT NULL,
    rate_foreign DOUBLE PRECISION NOT NULL,
    volatility DOUBLE PRECISION NOT NULL,
    maturity DATE NOT NULL,
    day_counter VARCHAR(20) NOT NULL,  -- e.g., "Actual360", "Actual365", etc.
    price DOUBLE PRECISION NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE
);
