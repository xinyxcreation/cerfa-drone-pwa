import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository';

export interface Role extends RowDataPacket {

    id: string;

    code: string;
    label: string;

    sort_order: number;

    is_active: boolean;

    created_at: Date;
    updated_at: Date;
    deleted_at: Date | null;

    sync_cursor: number;

}

export class RoleRepository extends BaseRepository {

    private readonly table = 'roles';

    public async findById(
        id: string
    ): Promise<Role | null> {

        return this.baseFindById<Role>(
            this.table,
            id
        );

    }

    public async findByCode(
        code: string
    ): Promise<Role | null> {

        return this.baseFindOneBy<Role>(
            this.table,
            'code',
            code
        );

    }

    public async findAll(): Promise<Role[]> {

        const [rows] = await this.db.query<Role[]>(
            `
            SELECT *
            FROM roles
            WHERE is_active = TRUE
            AND deleted_at IS NULL
            ORDER BY sort_order
            `
        );

        return rows;

    }

}
