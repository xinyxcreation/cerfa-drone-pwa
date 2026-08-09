CREATE TABLE sites (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,

    site_reference VARCHAR(100) NULL,

    name VARCHAR(150) NOT NULL,
    description TEXT NULL,

    client_id CHAR(36) NULL,
    category_id CHAR(36) NULL,

    default_drone_id CHAR(36) NULL,
    default_pilot_id CHAR(36) NULL,

    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255) NULL,

    postal_code VARCHAR(10) NOT NULL,
    city VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'France',

    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,

    prefecture_id CHAR(36) NULL,

    is_favorite BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    notes TEXT NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_sites
        PRIMARY KEY (id),

    CONSTRAINT uq_sites_company_reference
        UNIQUE (company_id, site_reference),

    INDEX idx_sites_company (company_id),
    INDEX idx_sites_client (client_id),
    INDEX idx_sites_category (category_id),
    INDEX idx_sites_default_drone (default_drone_id),
    INDEX idx_sites_default_pilot (default_pilot_id),
    INDEX idx_sites_prefecture (prefecture_id),
    INDEX idx_sites_name (name),
    INDEX idx_sites_favorite (is_favorite),
    INDEX idx_sites_active (is_active),
    INDEX idx_sites_deleted_at (deleted_at),
    INDEX idx_sites_sync_cursor (sync_cursor),

    CONSTRAINT fk_sites_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_sites_client
        FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sites_category
        FOREIGN KEY (category_id)
        REFERENCES mission_categories(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sites_default_drone
        FOREIGN KEY (default_drone_id)
        REFERENCES drones(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sites_default_pilot
        FOREIGN KEY (default_pilot_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_sites_prefecture
        FOREIGN KEY (prefecture_id)
        REFERENCES prefectures(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
