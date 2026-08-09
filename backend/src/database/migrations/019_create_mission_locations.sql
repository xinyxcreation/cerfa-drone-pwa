CREATE TABLE mission_locations (
    id CHAR(36) NOT NULL,

    mission_id CHAR(36) NOT NULL,

    site_id CHAR(36) NULL,
    drone_id CHAR(36) NOT NULL,
    prefecture_id CHAR(36) NOT NULL,

    name VARCHAR(150) NULL,

    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255) NULL,

    postal_code VARCHAR(10) NOT NULL,
    city VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'France',

    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,

    intervention_order SMALLINT UNSIGNED NOT NULL DEFAULT 1,

    is_completed BOOLEAN NOT NULL DEFAULT FALSE,

    notes TEXT NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_mission_locations
        PRIMARY KEY (id),

    INDEX idx_mission_locations_mission (mission_id),
    INDEX idx_mission_locations_site (site_id),
    INDEX idx_mission_locations_drone (drone_id),
    INDEX idx_mission_locations_prefecture (prefecture_id),
    INDEX idx_mission_locations_completed (is_completed),
    INDEX idx_mission_locations_deleted_at (deleted_at),
    INDEX idx_mission_locations_sync_cursor (sync_cursor),

    CONSTRAINT fk_mission_locations_mission
        FOREIGN KEY (mission_id)
        REFERENCES missions(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_mission_locations_site
        FOREIGN KEY (site_id)
        REFERENCES sites(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_mission_locations_drone
        FOREIGN KEY (drone_id)
        REFERENCES drones(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_mission_locations_prefecture
        FOREIGN KEY (prefecture_id)
        REFERENCES prefectures(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
