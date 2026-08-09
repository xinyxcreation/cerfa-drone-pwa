import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository';

export interface CompanyUser extends RowDataPacket {

    id: string;

    company_id: string;
    user_id: string;
    role_id: string;

    is_active: boolean;

    created_at: Date;
    updated_at: Date;
    deleted_at: Date | null;

    sync_cursor: number;

}

export class CompanyUserRepository extends BaseRepository {

    private readonly table = 'company_users';

    public async findById(
        id: string
    ): Promise<CompanyUser | null> {

        return this.baseFindById<CompanyUser>(
            this.table,
            id
        );

    }

    public async findByUserId(
        userId: string
    ): Promise<CompanyUser[]> {

        const [rows] = await this.db.query<CompanyUser[]>(
            `
            SELECT *
            FROM company_users
            WHERE user_id = ?
            AND deleted_at IS NULL
            AND is_active = TRUE
            ORDER BY created_at
            `,
            [userId]
        );

        return rows;

    }

    public async create(
        companyId: string,
        userId: string,
        roleId: string
    ): Promise<string> {

        return this.baseInsert(
            this.table,
            {
                company_id: companyId,
                user_id: userId,
                role_id: roleId,
                is_active: true
            }
        );

    }

    public async deactivate(
        id: string
    ): Promise<void> {

        await this.baseUpdate(
            this.table,
            id,
            {
                is_active: false
            }
        );

    }

    public async delete(
        id: string
    ): Promise<void> {

        await this.baseDelete(
            this.table,
            id
        );

    }

}
