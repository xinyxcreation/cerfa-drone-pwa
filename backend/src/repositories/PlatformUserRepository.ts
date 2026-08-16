import {
    RowDataPacket
} from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface PlatformUserRecord {
    id: string;

    user_id: string;

    platform_role_id: string;

    role_code: string;

    role_label: string;

    email: string;

    firstname: string;

    lastname: string;

    phone: string | null;

    is_active: boolean;
}

interface PlatformUserRow
    extends RowDataPacket {

    id: string;

    user_id: string;

    platform_role_id: string;

    role_code: string;

    role_label: string;

    email: string;

    firstname: string;

    lastname: string;

    phone: string | null;

    platform_user_active: number;

    role_active: number;

    user_active: number;
}

export class PlatformUserRepository
    extends BaseRepository {

    public async findByEmail(
        email: string
    ): Promise<PlatformUserRecord | null> {

        const [rows] =
        await this.db.query<
            PlatformUserRow[]
        >(`

            SELECT

                pu.id,

                pu.user_id,

                pu.platform_role_id,

                pr.code AS role_code,

                pr.label AS role_label,

                u.email,

                u.firstname,

                u.lastname,

                u.phone,

                pu.is_active AS platform_user_active,

                pr.is_active AS role_active,

                u.is_active AS user_active

            FROM platform_users pu

            INNER JOIN users u
                ON u.id = pu.user_id

            INNER JOIN platform_roles pr
                ON pr.id = pu.platform_role_id

            WHERE LOWER(u.email) = LOWER(?)

              AND pu.deleted_at IS NULL
              AND pr.deleted_at IS NULL
              AND u.deleted_at IS NULL

            LIMIT 1

        `, [
            email.trim().toLowerCase()
        ]);

        if (
            rows.length === 0
        ) {

            return null;

        }

        const row =
        rows[0];

        return {

            id:
            row.id,

            user_id:
            row.user_id,

            platform_role_id:
            row.platform_role_id,

            role_code:
            row.role_code,

            role_label:
            row.role_label,

            email:
            row.email,

            firstname:
            row.firstname,

            lastname:
            row.lastname,

            phone:
            row.phone,

            is_active:
            Boolean(
                row.platform_user_active
            )

        };

    }

    public async findByUserId(
        userId: string
    ): Promise<PlatformUserRecord | null> {

        const [rows] =
        await this.db.query<
            PlatformUserRow[]
        >(`

            SELECT

                pu.id,

                pu.user_id,

                pu.platform_role_id,

                pr.code AS role_code,

                pr.label AS role_label,

                u.email,

                u.firstname,

                u.lastname,

                u.phone,

                pu.is_active AS platform_user_active,

                pr.is_active AS role_active,

                u.is_active AS user_active

            FROM platform_users pu

            INNER JOIN users u
                ON u.id = pu.user_id

            INNER JOIN platform_roles pr
                ON pr.id = pu.platform_role_id

            WHERE pu.user_id = ?

              AND pu.deleted_at IS NULL
              AND pr.deleted_at IS NULL
              AND u.deleted_at IS NULL

            LIMIT 1

        `, [
            userId
        ]);

        if (
            rows.length === 0
        ) {

            return null;

        }

        const row =
        rows[0];

        return {

            id:
            row.id,

            user_id:
            row.user_id,

            platform_role_id:
            row.platform_role_id,

            role_code:
            row.role_code,

            role_label:
            row.role_label,

            email:
            row.email,

            firstname:
            row.firstname,

            lastname:
            row.lastname,

            phone:
            row.phone,

            is_active:
            Boolean(
                row.platform_user_active
            )

        };

    }

}
