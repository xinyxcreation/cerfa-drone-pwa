CREATE TABLE document_types (
    id CHAR(36) NOT NULL,

    entity_type_id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    label VARCHAR(150) NOT NULL,
    description TEXT NULL,

    default_validity_days SMALLINT UNSIGNED NULL,
    default_reminder_days SMALLINT UNSIGNED NOT NULL DEFAULT 30,

    is_required BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_document_types
        PRIMARY KEY (id),

    CONSTRAINT uq_document_types_code
        UNIQUE (code),

    INDEX idx_document_types_entity (entity_type_id),
    INDEX idx_document_types_sort_order (sort_order),
    INDEX idx_document_types_active (is_active),
    INDEX idx_document_types_deleted_at (deleted_at),
    INDEX idx_document_types_sync_cursor (sync_cursor),

    CONSTRAINT fk_document_types_entity_type
        FOREIGN KEY (entity_type_id)
        REFERENCES entity_types(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
