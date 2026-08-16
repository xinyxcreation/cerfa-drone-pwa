import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface User extends RowDataPacket {
    id: string;

    email: string;
    password_hash: string;

    firstname: string;
    lastname: string;

    phone: string | null;

    is_active: boolean;

    email_verified_at: Date | null;
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
            firstname: string;
            lastname: string;
            phone?: string | null;
        }
    ): Promise<string> {

        const userId =
        await this.baseInsert(
            this.table,
            {
                email:
                user.email.trim().toLowerCase(),

                password_hash:
                user.password_hash,

                firstname:
                user.firstname.trim(),

                lastname:
                user.lastname.trim(),

                phone:
                user.phone ?? null,

                is_active:
                true,

                email_verified_at:
                null,

                last_company_id:
                null,

                last_login_at:
                null
            }
        );

        const [plans] =
        await this.db.query<
            Array<RowDataPacket & { id: string }>
        >(
            `
            SELECT id
            FROM subscription_plans
            WHERE code = 'FREE'
            AND type = 'USER'
            AND is_active = TRUE
            AND deleted_at IS NULL
            LIMIT 1
            `
        );

        if (plans.length === 0) {
            throw new Error(
                'Plan utilisateur FREE introuvable.'
            );
        }

        await this.db.execute(
            `
            INSERT INTO user_subscriptions (
                id,
                user_id,
                subscription_plan_id,
                status,
                started_at,
                expires_at,
                cancelled_at,
                created_at,
                updated_at,
                sync_cursor
            )
            VALUES (
                UUID(),
                ?,
                ?,
                'ACTIVE',
                UTC_TIMESTAMP(6),
                NULL,
                NULL,
                UTC_TIMESTAMP(6),
                UTC_TIMESTAMP(6),
                0
            )
            `,
            [
                userId,
                plans[0].id
            ]
        );

        return userId;
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
                last_company_id:
                companyId
            }
        );
    }

    public async updateProfile(
        id: string,
        profile: {
            first_name: string;
            last_name: string;
            email: string;
            phone: string | null;
        }
    ): Promise<void> {

        await this.baseUpdate(
            this.table,
            id,
            {
                firstname:
                profile.first_name.trim(),

                lastname:
                profile.last_name.trim(),

                email:
                profile.email.trim().toLowerCase(),

                phone:
                profile.phone
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
