CREATE TABLE users (
    id CHAR(36) NOT NULL,

    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,

    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,

    phone VARCHAR(30) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    email_verified_at DATETIME(6) NULL,
    last_login_at DATETIME(6) NULL,

    last_company_id CHAR(36) NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_users
        PRIMARY KEY (id),

    CONSTRAINT uq_users_email
        UNIQUE (email),

    INDEX idx_users_last_company (last_company_id),
    INDEX idx_users_active (is_active),
    INDEX idx_users_deleted_at (deleted_at),
    INDEX idx_users_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
