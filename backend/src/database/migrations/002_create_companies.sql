CREATE TABLE companies (
    id CHAR(36) NOT NULL,

    name VARCHAR(150) NOT NULL,
    legal_name VARCHAR(255) NULL,
    contact_name VARCHAR(255) NULL,

    siret CHAR(14) NULL,
    alphatango_operator_number VARCHAR(50) NULL,

    email VARCHAR(255) NULL,
    phone VARCHAR(30) NULL,
    website_url VARCHAR(255) NULL,

    address_line_1 VARCHAR(255) NULL,
    address_line_2 VARCHAR(255) NULL,
    postal_code VARCHAR(10) NULL,
    city VARCHAR(150) NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'France',

    logo_path VARCHAR(255) NULL,
    signature_path VARCHAR(255) NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    notes TEXT NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_companies
        PRIMARY KEY (id),

    CONSTRAINT uq_companies_siret
        UNIQUE (siret),

    CONSTRAINT uq_companies_alphatango_operator_number
        UNIQUE (alphatango_operator_number),

    INDEX idx_companies_name (name),
    INDEX idx_companies_active (is_active),
    INDEX idx_companies_deleted_at (deleted_at),
    INDEX idx_companies_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
