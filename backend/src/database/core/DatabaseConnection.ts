import mysql, { Pool } from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

let pool: Pool | null = null;

export function getDatabase(): Pool {

    if (!pool) {

        pool = mysql.createPool({

            host: process.env.DB_HOST,
            port: Number(process.env.DB_PORT),
                                user: process.env.DB_USER,
                                password: process.env.DB_PASSWORD,
                                database: process.env.DB_NAME,

                                waitForConnections: true,
                                connectionLimit: 10,
                                queueLimit: 0,

                                charset: 'utf8mb4',
                                timezone: 'Z',

                                multipleStatements: true

        });

    }

    return pool;

}

export async function closeDatabase(): Promise<void> {
    if (pool) {
        await pool.end();
        pool = null;
    }
}
