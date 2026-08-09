CREATE TABLE notifications (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,

    user_id CHAR(36) NULL,

    notification_type_id CHAR(36) NOT NULL,

    priority TINYINT UNSIGNED NOT NULL DEFAULT 1,

    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    entity_type_id CHAR(36) NULL,
    entity_id CHAR(36) NULL,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at DATETIME(6) NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_notifications
        PRIMARY KEY (id),

    CONSTRAINT chk_notifications_priority
        CHECK (priority BETWEEN 1 AND 4),

    INDEX idx_notifications_company (company_id),
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_type (notification_type_id),
    INDEX idx_notifications_priority (priority),
    INDEX idx_notifications_entity (entity_type_id, entity_id),
    INDEX idx_notifications_read (is_read),
    INDEX idx_notifications_deleted_at (deleted_at),
    INDEX idx_notifications_sync_cursor (sync_cursor),

    CONSTRAINT fk_notifications_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_notifications_type
        FOREIGN KEY (notification_type_id)
        REFERENCES notification_types(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_notifications_entity_type
        FOREIGN KEY (entity_type_id)
        REFERENCES entity_types(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
