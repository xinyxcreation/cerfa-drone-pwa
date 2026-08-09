CREATE TABLE clients (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,

    customer_reference VARCHAR(50) NULL,

    name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(255) NULL,

    email VARCHAR(255) NULL,
    phone VARCHAR(30) NULL,

    address_line_1 VARCHAR(255) NULL,
    address_line_2 VARCHAR(255) NULL,

    postal_code VARCHAR(10) NULL,
    city VARCHAR(150) NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'France',

    notes TEXT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_clients
        PRIMARY KEY (id),

    CONSTRAINT uq_clients_company_reference
        UNIQUE (company_id, customer_reference),

    INDEX idx_clients_company (company_id),
    INDEX idx_clients_name (name),
    INDEX idx_clients_active (is_active),
    INDEX idx_clients_deleted_at (deleted_at),
    INDEX idx_clients_sync_cursor (sync_cursor),

    CONSTRAINT fk_clients_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
