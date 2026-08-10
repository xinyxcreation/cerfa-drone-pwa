import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface CompanyUser extends RowDataPacket {

    id: string;

    company_id: string;
    user_id: string;
    role_id: string;

    is_pilot: boolean;
    is_active: boolean;

    joined_at: Date;
    left_at: Date | null;

    created_at: Date;
    updated_at: Date;
    deleted_at: Date | null;

    sync_cursor: number;
}

export interface CompanyMember extends RowDataPacket {

    id: string;

    company_id: string;
    user_id: string;

    email: string;
    firstname: string;
    lastname: string;
    phone: string | null;

    joined_at: Date;

    role_code: string;
    role_label: string;

    is_pilot: boolean;
}

export class CompanyUserRepository extends BaseRepository {

    private readonly table = 'company_users';

    // ============================================================
    // RATTACHEMENT
    // ============================================================

    public async findById(
        id: string
    ): Promise<CompanyUser | null> {

        return this.baseFindById<CompanyUser>(
            this.table,
            id
        );
    }

    public async findByCompanyAndUser(
        companyId: string,
        userId: string
    ): Promise<CompanyUser | null> {

        const [rows] =
        await this.db.query<CompanyUser[]>(
            `
            SELECT *
            FROM company_users
            WHERE company_id = ?
            AND user_id = ?
            AND deleted_at IS NULL
            AND is_active = TRUE
            LIMIT 1
            `,
            [
                companyId,
                userId
            ]
        );

        return rows.length > 0
            ? rows[0]
            : null;
    }

    public async findByUserId(
        userId: string
    ): Promise<CompanyUser[]> {

        const [rows] =
        await this.db.query<CompanyUser[]>(
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

    // ============================================================
    // MEMBRES
    // ============================================================

    public async findMembersByCompanyId(
        companyId: string
    ): Promise<CompanyMember[]> {

        const [rows] =
        await this.db.query<CompanyMember[]>(
            `
            SELECT

                cu.id,
                cu.company_id,
                cu.user_id,

                u.email,
                u.firstname,
                u.lastname,
                u.phone,

                cu.joined_at,

                r.code AS role_code,
                r.label AS role_label,

                cu.is_pilot

            FROM company_users cu

            INNER JOIN users u
                ON u.id = cu.user_id

            INNER JOIN roles r
                ON r.id = cu.role_id

            WHERE cu.company_id = ?

            AND cu.is_active = TRUE
            AND cu.deleted_at IS NULL

            AND u.is_active = TRUE
            AND u.deleted_at IS NULL

            AND r.is_active = TRUE
            AND r.deleted_at IS NULL

            ORDER BY
                u.lastname,
                u.firstname,
                u.email
            `,
            [companyId]
        );

        return rows;
    }

    // ============================================================
    // PILOTES
    // ============================================================

    public async findPilotsByCompanyId(
        companyId: string
    ): Promise<CompanyMember[]> {

        const [rows] =
        await this.db.query<CompanyMember[]>(
            `
            SELECT

                cu.id,
                cu.company_id,
                cu.user_id,

                u.email,
                u.firstname,
                u.lastname,
                u.phone,

                cu.joined_at,

                r.code AS role_code,
                r.label AS role_label,

                cu.is_pilot

            FROM company_users cu

            INNER JOIN users u
                ON u.id = cu.user_id

            INNER JOIN roles r
                ON r.id = cu.role_id

            WHERE cu.company_id = ?

            AND cu.is_pilot = TRUE

            AND cu.is_active = TRUE
            AND cu.deleted_at IS NULL

            AND u.is_active = TRUE
            AND u.deleted_at IS NULL

            AND r.is_active = TRUE
            AND r.deleted_at IS NULL

            ORDER BY
                u.lastname,
                u.firstname,
                u.email
            `,
            [companyId]
        );

        return rows;
    }

    // ============================================================
    // CREATION DU RATTACHEMENT
    // ============================================================

    public async create(
        companyId: string,
        userId: string,
        roleId: string,
        isPilot = false
    ): Promise<string> {

        return this.baseInsert(
            this.table,
            {
                company_id:
                companyId,

                user_id:
                userId,

                role_id:
                roleId,

                is_pilot:
                isPilot,

                is_active:
                true,

                joined_at:
                new Date(),

                left_at:
                null
            }
        );
    }

    // ============================================================
    // ACTIVER LE STATUT PILOTE
    // ============================================================

    public async setPilot(
        companyId: string,
        userId: string,
        isPilot: boolean
    ): Promise<void> {

        const membership =
        await this.findByCompanyAndUser(
            companyId,
            userId
        );

        if (!membership) {
            throw new Error(
                'Utilisateur non associé à cette entreprise.'
            );
        }

        await this.baseUpdate(
            this.table,
            membership.id,
            {
                is_pilot:
                isPilot
            }
        );
    }

    // ============================================================
    // DESACTIVER UN PILOTE
    // ============================================================

    public async deactivatePilot(
        companyId: string,
        userId: string
    ): Promise<void> {

        const membership =
        await this.findByCompanyAndUser(
            companyId,
            userId
        );

        if (!membership) {
            throw new Error(
                'Utilisateur non associé à cette entreprise.'
            );
        }

        await this.baseUpdate(
            this.table,
            membership.id,
            {
                is_pilot: false
            }
        );
    }

    // ============================================================
    // DESACTIVER LE RATTACHEMENT
    // ============================================================

    public async deactivate(
        id: string
    ): Promise<void> {

        await this.baseUpdate(
            this.table,
            id,
            {
                is_active:
                false,

                is_pilot:
                false,

                left_at:
                new Date()
            }
        );
    }

    // ============================================================
    // SUPPRESSION LOGIQUE
    // ============================================================

    public async delete(
        id: string
    ): Promise<void> {

        await this.baseDelete(
            this.table,
            id
        );
    }
}
