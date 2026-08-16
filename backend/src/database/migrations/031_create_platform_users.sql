CREATE TABLE platform_users (
    id CHAR(36) NOT NULL,

    user_id CHAR(36) NOT NULL,
    platform_role_id CHAR(36) NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_platform_users
        PRIMARY KEY (id),

    CONSTRAINT uq_platform_users_user
        UNIQUE (user_id),

    INDEX idx_platform_users_role (platform_role_id),
    INDEX idx_platform_users_active (is_active),

    CONSTRAINT fk_platform_users_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_platform_users_role
        FOREIGN KEY (platform_role_id)
        REFERENCES platform_roles(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
