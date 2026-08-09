CREATE TABLE missions (
    id CHAR(36) NOT NULL,

    company_id CHAR(36) NOT NULL,
    client_id CHAR(36) NOT NULL,
    pilot_id CHAR(36) NOT NULL,
    category_id CHAR(36) NOT NULL,

    mission_status_id CHAR(36) NOT NULL,

    reference VARCHAR(50) NULL,

    title VARCHAR(255) NOT NULL,
    description TEXT NULL,

    planned_at DATETIME(6) NULL,
    started_at DATETIME(6) NULL,
    completed_at DATETIME(6) NULL,

    is_archived BOOLEAN NOT NULL DEFAULT FALSE,

    notes TEXT NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_missions
        PRIMARY KEY (id),

    CONSTRAINT uq_missions_company_reference
        UNIQUE (company_id, reference),

    INDEX idx_missions_company (company_id),
    INDEX idx_missions_client (client_id),
    INDEX idx_missions_pilot (pilot_id),
    INDEX idx_missions_category (category_id),
    INDEX idx_missions_status (mission_status_id),
    INDEX idx_missions_planned_at (planned_at),
    INDEX idx_missions_archived (is_archived),
    INDEX idx_missions_deleted_at (deleted_at),
    INDEX idx_missions_sync_cursor (sync_cursor),

    CONSTRAINT fk_missions_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_missions_client
        FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_missions_pilot
        FOREIGN KEY (pilot_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_missions_category
        FOREIGN KEY (category_id)
        REFERENCES mission_categories(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_missions_status
        FOREIGN KEY (mission_status_id)
        REFERENCES mission_statuses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
