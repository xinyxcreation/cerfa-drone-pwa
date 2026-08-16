CREATE TABLE subscription_prices (
    id CHAR(36) NOT NULL,

    subscription_plan_id CHAR(36) NOT NULL,

    billing_period ENUM('MONTHLY','YEARLY') NOT NULL,

    amount_cents INT UNSIGNED NOT NULL DEFAULT 0,

    currency CHAR(3) NOT NULL DEFAULT 'EUR',

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_subscription_prices
        PRIMARY KEY (id),

    CONSTRAINT uq_subscription_prices_plan_period
        UNIQUE (
            subscription_plan_id,
            billing_period
        ),

    INDEX idx_subscription_prices_plan (
        subscription_plan_id
    ),

    INDEX idx_subscription_prices_period (
        billing_period
    ),

    INDEX idx_subscription_prices_active (
        is_active
    ),

    INDEX idx_subscription_prices_deleted_at (
        deleted_at
    ),

    INDEX idx_subscription_prices_sync_cursor (
        sync_cursor
    ),

    CONSTRAINT fk_subscription_prices_plan
        FOREIGN KEY (subscription_plan_id)
        REFERENCES subscription_plans(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


UPDATE subscription_plans
SET
    code = 'PREMIUM',
    label = 'Premium'
WHERE code = 'PREMIUM'
  AND type = 'USER';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'MONTHLY',
    0,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'FREE';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'YEARLY',
    0,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'FREE';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'MONTHLY',
    100,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'PREMIUM';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'YEARLY',
    1000,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'PREMIUM';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'MONTHLY',
    0,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'FREE_COMPANY';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'YEARLY',
    0,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'FREE_COMPANY';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'MONTHLY',
    500,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'STARTER';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'YEARLY',
    5000,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'STARTER';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'MONTHLY',
    1000,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'PRO';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'YEARLY',
    10000,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'PRO';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'MONTHLY',
    2000,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'BUSINESS';


INSERT INTO subscription_prices (
    id,
    subscription_plan_id,
    billing_period,
    amount_cents,
    currency,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
SELECT
    UUID(),
    id,
    'YEARLY',
    20000,
    'EUR',
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
FROM subscription_plans
WHERE code = 'BUSINESS';
