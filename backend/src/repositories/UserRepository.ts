import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository';

export interface User extends RowDataPacket {

    id: string;

    email: string;
    password_hash: string;

    first_name: string;
    last_name: string;

    phone: string | null;

    is_active: boolean;

    last_company_id: string | null;
    last_login_at: Date | null;

    created_at: Date;
    updated_at: Date;
    deleted_at: Date | null;

    sync_cursor: number;

}

export class UserRepository extends BaseRepository {

    private readonly table = 'users';

    public async findById(
        id: string
    ): Promise<User | null> {

        return this.baseFindById<User>(
            this.table,
            id
        );

    }

    public async findByEmail(
        email: string
    ): Promise<User | null> {

        return this.baseFindOneBy<User>(
            this.table,
            'email',
            email.trim().toLowerCase()
        );

    }

    public async create(
        user: {
            email: string;
            password_hash: string;
            first_name: string;
            last_name: string;
            phone?: string | null;
        }
    ): Promise<string> {

        return this.baseInsert(
            this.table,
            {
                email: user.email,
                password_hash: user.password_hash,
                first_name: user.first_name,
                last_name: user.last_name,
                phone: user.phone ?? null,
                is_active: true,
                last_company_id: null,
                last_login_at: null
            }
        );

    }

    public async updateLastLogin(
        id: string
    ): Promise<void> {

        await this.db.execute(
            `
            UPDATE users
            SET
            last_login_at = UTC_TIMESTAMP(6),
                              updated_at = UTC_TIMESTAMP(6)
                              WHERE id = ?
                              `,
                              [id]
        );

    }

    public async updateLastCompany(
        id: string,
        companyId: string | null
    ): Promise<void> {

        await this.baseUpdate(
            this.table,
            id,
            {
                last_company_id: companyId
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
