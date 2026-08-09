CREATE TABLE company_settings (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,

    cerfa_version VARCHAR(20) NOT NULL DEFAULT '15476*04',

    default_response_deadline_days SMALLINT UNSIGNED NOT NULL DEFAULT 10,

    default_document_reminder_days SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    default_certification_reminder_days SMALLINT UNSIGNED NOT NULL DEFAULT 30,

    default_pdf_filename VARCHAR(255) NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_company_settings
        PRIMARY KEY (id),

    CONSTRAINT uq_company_settings_company
        UNIQUE (company_id),

    CONSTRAINT chk_company_settings_deadline
        CHECK (default_response_deadline_days > 0),

    CONSTRAINT chk_company_settings_document_reminder
        CHECK (default_document_reminder_days >= 0),

    CONSTRAINT chk_company_settings_certification_reminder
        CHECK (default_certification_reminder_days >= 0),

    INDEX idx_company_settings_sync_cursor (sync_cursor),

    CONSTRAINT fk_company_settings_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
