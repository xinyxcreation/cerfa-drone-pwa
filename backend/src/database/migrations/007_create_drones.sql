CREATE TABLE drones (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,

    nickname VARCHAR(100) NULL,

    manufacturer VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,

    serial_number VARCHAR(100) NOT NULL,

    alphatango_aircraft_number VARCHAR(50) NOT NULL,

    drone_class VARCHAR(10) NULL,

    weight_g INT UNSIGNED NULL,

    notes TEXT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_drones
        PRIMARY KEY (id),

    CONSTRAINT uq_drones_company_serial_number
        UNIQUE (company_id, serial_number),

    CONSTRAINT uq_drones_company_alphatango
        UNIQUE (company_id, alphatango_aircraft_number),

    INDEX idx_drones_company (company_id),
    INDEX idx_drones_nickname (nickname),
    INDEX idx_drones_manufacturer (manufacturer),
    INDEX idx_drones_model (model),
    INDEX idx_drones_active (is_active),
    INDEX idx_drones_deleted_at (deleted_at),
    INDEX idx_drones_sync_cursor (sync_cursor),

    CONSTRAINT fk_drones_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
