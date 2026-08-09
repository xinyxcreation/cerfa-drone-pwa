import { promises as fs } from 'node:fs';
import path from 'node:path';
import { Pool } from 'mysql2/promise';

export abstract class SqlScriptRunner {

    protected constructor(
        protected readonly db: Pool
    ) {}

    protected async getSqlFiles(directory: string): Promise<string[]> {

        return (await fs.readdir(directory))
        .filter(file => file.endsWith('.sql'))
        .sort();

    }

    protected async executeFile(
        directory: string,
        file: string
    ): Promise<void> {

        const sql = await fs.readFile(
            path.join(directory, file),
                                      'utf8'
        );

        const connection = await this.db.getConnection();

        try {

            await connection.beginTransaction();

            await connection.query(sql);

            await connection.commit();

        } catch (error) {

            await connection.rollback();

            throw error;

        } finally {

            connection.release();

        }

    }

}
