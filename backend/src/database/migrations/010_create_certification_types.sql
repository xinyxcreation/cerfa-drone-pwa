CREATE TABLE certification_types (
    id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    label VARCHAR(150) NOT NULL,
    description TEXT NULL,

    default_validity_days SMALLINT UNSIGNED NULL,
    default_reminder_days SMALLINT UNSIGNED NOT NULL DEFAULT 30,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_certification_types
        PRIMARY KEY (id),

    CONSTRAINT uq_certification_types_code
        UNIQUE (code),

    INDEX idx_certification_types_sort_order (sort_order),
    INDEX idx_certification_types_active (is_active),
    INDEX idx_certification_types_deleted_at (deleted_at),
    INDEX idx_certification_types_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
