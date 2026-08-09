import {
    Pool,
    ResultSetHeader,
    RowDataPacket
} from 'mysql2/promise';

import { v7 as uuidv7 } from 'uuid';

import { getDatabase } from '../database/core/DatabaseConnection.js';

export abstract class BaseRepository {

    protected readonly db: Pool;

    public constructor() {

        this.db = getDatabase();

    }

    protected async baseFindById<T>(
        table: string,
        id: string
    ): Promise<T | null> {

        const [rows] = await this.db.query<RowDataPacket[]>(
            `
            SELECT *
            FROM ${table}
            WHERE id = ?
            AND deleted_at IS NULL
            LIMIT 1
            `,
            [id]
        );

        return rows.length > 0
        ? rows[0] as T
        : null;

    }

    protected async baseFindOneBy<T>(
        table: string,
        column: string,
        value: unknown
    ): Promise<T | null> {

        const [rows] = await this.db.query<RowDataPacket[]>(
            `
            SELECT *
            FROM ${table}
            WHERE ${column} = ?
            AND deleted_at IS NULL
            LIMIT 1
            `,
            [value]
        );

        return rows.length > 0
        ? rows[0] as T
        : null;

    }

    protected async baseInsert(
        table: string,
        data: Record<string, unknown>
    ): Promise<string> {

        const id = uuidv7();

        const values = {
            id,
            ...data
        };

        const columns = Object.keys(values);

        const placeholders = columns
        .map(() => '?')
        .join(', ');

        await this.db.execute<ResultSetHeader>(
            `
            INSERT INTO ${table}
            (
                ${columns.join(', ')},
             created_at,
             updated_at,
             sync_cursor
            )
            VALUES
            (
                ${placeholders},
             UTC_TIMESTAMP(6),
             UTC_TIMESTAMP(6),
             0
            )
            `,
            Object.values(values)
        );

        return id;

    }

    protected async baseUpdate(
        table: string,
        id: string,
        data: Record<string, unknown>
    ): Promise<void> {

        const columns = Object.keys(data);

        const sql = columns
        .map(column => `${column} = ?`)
        .join(', ');

        await this.db.query(
            `
            UPDATE ${table}
            SET
            ${sql},
            updated_at = UTC_TIMESTAMP(6)
            WHERE id = ?
            `,
            [
                ...Object.values(data),
                              id
            ]
        );

    }

    protected async baseDelete(
        table: string,
        id: string
    ): Promise<void> {

        await this.db.execute(
            `
            UPDATE ${table}
            SET
            deleted_at = UTC_TIMESTAMP(6),
                              updated_at = UTC_TIMESTAMP(6)
                              WHERE id = ?
                              `,
                              [id]
        );

    }

}
