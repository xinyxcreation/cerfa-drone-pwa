import {
    Pool,
    ResultSetHeader,
    RowDataPacket
} from 'mysql2/promise';

import { v7 as uuidv7 } from 'uuid';

export abstract class BaseSeeder {

    protected async exists(
        db: Pool,
        table: string,
        column: string,
        value: unknown
    ): Promise<boolean> {

        const [rows] = await db.query<RowDataPacket[]>(
            `
            SELECT 1
            FROM ${table}
            WHERE ${column} = ?
            LIMIT 1
            `,
            [value]
        );

        return rows.length > 0;

    }

    protected async getIdByCode(
        db: Pool,
        table: string,
        code: string
    ): Promise<string> {

        const [rows] = await db.query<RowDataPacket[]>(
            `
            SELECT id
            FROM ${table}
            WHERE code = ?
            LIMIT 1
            `,
            [code]
        );

        if (rows.length === 0) {

            throw new Error(
                `Aucun enregistrement '${code}' trouvé dans '${table}'.`
            );

        }

        return rows[0].id;

    }

    protected async insert(
        db: Pool,
        table: string,
        data: Record<string, unknown>
    ): Promise<void> {

        const values = {
            id: uuidv7(),
            ...data,
            created_at: new Date(),
            updated_at: new Date(),
            sync_cursor: 0
        };

        const columns = Object.keys(values);

        const placeholders = columns
        .map(() => '?')
        .join(', ');

        await db.execute<ResultSetHeader>(
            `
            INSERT INTO ${table}
            (
                ${columns.join(', ')}
            )
            VALUES
            (
                ${placeholders}
            )
            `,
            Object.values(values)
        );

    }

    protected async insertIfNotExists(
        db: Pool,
        table: string,
        column: string,
        value: unknown,
        data: Record<string, unknown>
    ): Promise<void> {

        const exists = await this.exists(
            db,
            table,
            column,
            value
        );

        if (exists) {
            return;
        }

        await this.insert(
            db,
            table,
            data
        );

    }

}
