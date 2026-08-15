CREATE TABLE company_subscriptions (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,
    subscription_plan_id CHAR(36) NOT NULL,

    status ENUM('ACTIVE','CANCELLED','EXPIRED','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',

    started_at DATETIME(6) NOT NULL,
    expires_at DATETIME(6) NULL,
    cancelled_at DATETIME(6) NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_company_subscriptions
        PRIMARY KEY (id),

    INDEX idx_company_subscriptions_company (company_id),
    INDEX idx_company_subscriptions_plan (subscription_plan_id),
    INDEX idx_company_subscriptions_status (status),
    INDEX idx_company_subscriptions_active (company_id, status),

    CONSTRAINT fk_company_subscriptions_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_company_subscriptions_plan
        FOREIGN KEY (subscription_plan_id)
        REFERENCES subscription_plans(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
