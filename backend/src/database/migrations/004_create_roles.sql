CREATE TABLE roles (
    id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL,

    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_roles
        PRIMARY KEY (id),

    CONSTRAINT uq_roles_code
        UNIQUE (code),

    INDEX idx_roles_sort_order (sort_order),
    INDEX idx_roles_active (is_active),
    INDEX idx_roles_deleted_at (deleted_at),
    INDEX idx_roles_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;-- 003_create_roles.sql

INSERT INTO roles (
    id,
    code,
    label,
    sort_order,
    is_active,
    created_at,
    updated_at,
    sync_cursor
) VALUES
(UUID(), 'manager', 'Gérant', 1, TRUE, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6), 0),
(UUID(), 'pilot', 'Pilote', 2, TRUE, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6), 0);
