CREATE TABLE prefectures (
    id CHAR(36) NOT NULL,

    code VARCHAR(20) NOT NULL,
    department_code VARCHAR(3) NOT NULL,
    department_name VARCHAR(100) NOT NULL,

    prefecture_name VARCHAR(150) NOT NULL,

    address VARCHAR(255) NULL,
    postal_code VARCHAR(10) NULL,
    city VARCHAR(100) NULL,
    phone VARCHAR(30) NULL,

    email VARCHAR(255) NULL,
    website_url VARCHAR(255) NULL,

    legal_response_days SMALLINT UNSIGNED NOT NULL DEFAULT 10,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deleted_at DATETIME(6) NULL,

    sync_cursor BIGINT UNSIGNED NOT NULL DEFAULT 0,

    CONSTRAINT pk_prefectures
        PRIMARY KEY (id),

    CONSTRAINT uq_prefectures_code
        UNIQUE (code),

    INDEX idx_prefectures_department_code (department_code),
    INDEX idx_prefectures_department_name (department_name),
    INDEX idx_prefectures_active (is_active),
    INDEX idx_prefectures_deleted_at (deleted_at),
    INDEX idx_prefectures_sync_cursor (sync_cursor)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
