import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository';

export interface ReferenceItem extends RowDataPacket {

    id: string;

    code: string;

    label: string;

    description: string | null;

    sort_order: number;

    is_active: boolean;

    created_at: Date;

    updated_at: Date;

    deleted_at: Date | null;

    sync_cursor: number;

}

export class ReferenceRepository extends BaseRepository {

    public async findById(
        table: string,
        id: string
    ): Promise<ReferenceItem | null> {

        return this.baseFindById<ReferenceItem>(
            table,
            id
        );

    }

    public async findByCode(
        table: string,
        code: string
    ): Promise<ReferenceItem | null> {

        return this.baseFindOneBy<ReferenceItem>(
            table,
            'code',
            code
        );

    }

    public async findAll(
        table: string
    ): Promise<ReferenceItem[]> {

        const [rows] = await this.db.query<ReferenceItem[]>(
            `
            SELECT *
            FROM ${table}
            WHERE deleted_at IS NULL
            AND is_active = TRUE
            ORDER BY sort_order
            `
        );

        return rows;

    }

}
