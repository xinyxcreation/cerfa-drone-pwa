CREATE TABLE entity_types (
    id CHAR(36) NOT NULL,

    code VARCHAR(30) NOT NULL,
    label VARCHAR(100) NOT NULL,

    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_entity_types
        PRIMARY KEY (id),

    CONSTRAINT uq_entity_types_code
        UNIQUE (code),

    INDEX idx_entity_types_sort_order (sort_order),
    INDEX idx_entity_types_active (is_active),
    INDEX idx_entity_types_deleted_at (deleted_at),
    INDEX idx_entity_types_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

INSERT INTO entity_types (
    id,
    code,
    label,
    sort_order,
    is_active,
    created_at,
    updated_at,
    sync_cursor
)
VALUES
(
    'UUID_V7_COMPANY',
    'company',
    'Entreprise',
    1,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    'UUID_V7_PILOT',
    'pilot',
    'Pilote',
    2,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    'UUID_V7_DRONE',
    'drone',
    'Drone',
    3,
    TRUE,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
);
