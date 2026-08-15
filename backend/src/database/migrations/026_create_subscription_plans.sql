CREATE TABLE subscription_plans (
    id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    type ENUM('USER','COMPANY') NOT NULL,

    label VARCHAR(100) NOT NULL,

    price_cents INT UNSIGNED NOT NULL DEFAULT 0,

    ads_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    max_pilots SMALLINT UNSIGNED NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_subscription_plans
        PRIMARY KEY (id),

    CONSTRAINT uq_subscription_plans_code
        UNIQUE (code),

    INDEX idx_subscription_plans_type (type),
    INDEX idx_subscription_plans_active (is_active),
    INDEX idx_subscription_plans_deleted_at (deleted_at),
    INDEX idx_subscription_plans_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

INSERT INTO subscription_plans (
    id,
    code,
    type,
    label,
    price_cents,
    ads_enabled,
    max_pilots,
    is_active,
    created_at,
    updated_at,
    sync_cursor
) VALUES
(
    UUID(),
    'FREE',
    'USER',
    'Gratuit',
    0,
    TRUE,
    NULL,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    UUID(),
    'PREMIUM',
    'USER',
    'Premium',
    0,
    FALSE,
    NULL,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    UUID(),
    'FREE_COMPANY',
    'COMPANY',
    'Free',
    0,
    FALSE,
    1,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    UUID(),
    'STARTER',
    'COMPANY',
    'Starter',
    0,
    FALSE,
    5,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    UUID(),
    'PRO',
    'COMPANY',
    'Pro',
    0,
    FALSE,
    10,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    UUID(),
    'BUSINESS',
    'COMPANY',
    'Business',
    0,
    FALSE,
    20,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
);
