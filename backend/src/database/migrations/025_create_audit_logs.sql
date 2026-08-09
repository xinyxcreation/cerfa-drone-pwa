CREATE TABLE audit_logs (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NULL,
    user_id CHAR(36) NULL,

    audit_action_id CHAR(36) NOT NULL,

    entity_type_id CHAR(36) NULL,
    entity_id CHAR(36) NULL,

    description TEXT NULL,

    metadata JSON NULL,

    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(255) NULL,

    created_at DATETIME(6) NOT NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_audit_logs
        PRIMARY KEY (id),

    INDEX idx_audit_logs_company (company_id),
    INDEX idx_audit_logs_user (user_id),
    INDEX idx_audit_logs_action (audit_action_id),
    INDEX idx_audit_logs_entity (entity_type_id, entity_id),
    INDEX idx_audit_logs_created_at (created_at),
    INDEX idx_audit_logs_sync_cursor (sync_cursor),

    CONSTRAINT fk_audit_logs_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_audit_logs_action
        FOREIGN KEY (audit_action_id)
        REFERENCES audit_actions(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_audit_logs_entity_type
        FOREIGN KEY (entity_type_id)
        REFERENCES entity_types(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
