CREATE TABLE certifications (
    id CHAR(36) NOT NULL,

    entity_type_id CHAR(36) NOT NULL,
    entity_id CHAR(36) NOT NULL,

    certification_type_id CHAR(36) NOT NULL,

    reference VARCHAR(100) NULL,

    obtained_at DATE NOT NULL,
    expires_at DATE NULL,

    reminder_days SMALLINT UNSIGNED NULL,

    is_valid BOOLEAN NOT NULL DEFAULT TRUE,

    notes TEXT NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_certifications
        PRIMARY KEY (id),

    INDEX idx_certifications_entity (entity_type_id, entity_id),
    INDEX idx_certifications_type (certification_type_id),
    INDEX idx_certifications_expires_at (expires_at),
    INDEX idx_certifications_valid (is_valid),
    INDEX idx_certifications_deleted_at (deleted_at),
    INDEX idx_certifications_sync_cursor (sync_cursor),

    CONSTRAINT fk_certifications_entity_type
        FOREIGN KEY (entity_type_id)
        REFERENCES entity_types(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_certifications_type
        FOREIGN KEY (certification_type_id)
        REFERENCES certification_types(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;-- 011_create_pilot_certifications.sql
