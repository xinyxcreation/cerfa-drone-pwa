CREATE TABLE cerfa_forms (
    id CHAR(36) NOT NULL,

    mission_location_id CHAR(36) NOT NULL,

    cerfa_status_id CHAR(36) NOT NULL,

    prefecture_id CHAR(36) NOT NULL,

    response_number VARCHAR(100) NULL,

    generated_at DATETIME(6) NOT NULL,

    sent_at DATETIME(6) NULL,

    legal_deadline_at DATETIME(6) NULL,

    response_at DATETIME(6) NULL,

    snapshot JSON NOT NULL,

    response_comment TEXT NULL,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_cerfa_forms
        PRIMARY KEY (id),

    INDEX idx_cerfa_forms_location (mission_location_id),
    INDEX idx_cerfa_forms_status (cerfa_status_id),
    INDEX idx_cerfa_forms_prefecture (prefecture_id),
    INDEX idx_cerfa_forms_generated_at (generated_at),
    INDEX idx_cerfa_forms_sent_at (sent_at),
    INDEX idx_cerfa_forms_response_at (response_at),
    INDEX idx_cerfa_forms_deadline (legal_deadline_at),
    INDEX idx_cerfa_forms_deleted_at (deleted_at),
    INDEX idx_cerfa_forms_sync_cursor (sync_cursor),

    CONSTRAINT fk_cerfa_forms_location
        FOREIGN KEY (mission_location_id)
        REFERENCES mission_locations(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_cerfa_forms_status
        FOREIGN KEY (cerfa_status_id)
        REFERENCES cerfa_statuses(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_cerfa_forms_prefecture
        FOREIGN KEY (prefecture_id)
        REFERENCES prefectures(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
