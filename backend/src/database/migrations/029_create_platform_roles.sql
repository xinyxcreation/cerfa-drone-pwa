CREATE TABLE platform_roles (
    id CHAR(36) NOT NULL,

    code VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_platform_roles
        PRIMARY KEY (id),

    CONSTRAINT uq_platform_roles_code
        UNIQUE (code)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

INSERT INTO platform_roles (
    id,
    code,
    label,
    created_at,
    updated_at,
    sync_cursor
) VALUES
(
    UUID(),
    'ADMIN',
    'Administrateur',
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
),
(
    UUID(),
    'MODERATOR',
    'Modérateur',
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6),
    0
);
