CREATE TABLE cerfa_statuses (
    id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL,
    description TEXT NULL,

    color VARCHAR(7) NULL,
    icon VARCHAR(50) NULL,

    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_cerfa_statuses
        PRIMARY KEY (id),

    CONSTRAINT uq_cerfa_statuses_code
        UNIQUE (code),

    INDEX idx_cerfa_statuses_sort_order (sort_order),
    INDEX idx_cerfa_statuses_active (is_active),
    INDEX idx_cerfa_statuses_deleted_at (deleted_at),
    INDEX idx_cerfa_statuses_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
