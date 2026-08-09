CREATE TABLE audit_actions (
    id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL,
    description TEXT NULL,

    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_audit_actions
        PRIMARY KEY (id),

    CONSTRAINT uq_audit_actions_code
        UNIQUE (code),

    CONSTRAINT chk_audit_actions_sort_order
        CHECK (sort_order >= 0),

    INDEX idx_audit_actions_sort_order (sort_order),
    INDEX idx_audit_actions_active (is_active),
    INDEX idx_audit_actions_deleted_at (deleted_at),
    INDEX idx_audit_actions_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
