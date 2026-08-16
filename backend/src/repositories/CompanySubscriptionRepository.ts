import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface CompanySubscription extends RowDataPacket {

    id: string;

    company_id: string;
    subscription_plan_id: string;

    status: 'ACTIVE' | 'CANCELLED' | 'EXPIRED' | 'SUSPENDED';

    started_at: Date;
    expires_at: Date | null;
    cancelled_at: Date | null;

    plan_code: string;
    plan_label: string;
    max_users: number | null;

}

export class CompanySubscriptionRepository
extends BaseRepository {

    public async findActiveByCompanyId(
        companyId: string
    ): Promise<CompanySubscription | null> {

        const [rows] =
        await this.db.query<CompanySubscription[]>(
            `
            SELECT

                cs.id,
                cs.company_id,
                cs.subscription_plan_id,

                cs.status,

                cs.started_at,
                cs.expires_at,
                cs.cancelled_at,

                sp.code AS plan_code,
                sp.label AS plan_label,
                sp.max_users

            FROM company_subscriptions cs

            INNER JOIN subscription_plans sp
                ON sp.id = cs.subscription_plan_id

            WHERE cs.company_id = ?

            AND cs.status = 'ACTIVE'

            AND cs.deleted_at IS NULL

            AND sp.type = 'COMPANY'
            AND sp.is_active = TRUE
            AND sp.deleted_at IS NULL

            AND (
                cs.expires_at IS NULL
                OR cs.expires_at > UTC_TIMESTAMP(6)
            )

            ORDER BY cs.started_at DESC

            LIMIT 1
            `,
            [companyId]
        );

        return rows.length > 0
            ? rows[0]
            : null;
    }

    public async createFree(
        companyId: string
    ): Promise<string> {

        const [plans] =
        await this.db.query<
            Array<RowDataPacket & { id: string }>
        >(
            `
            SELECT id
            FROM subscription_plans
            WHERE code = 'FREE_COMPANY'
            AND type = 'COMPANY'
            AND is_active = TRUE
            AND deleted_at IS NULL
            LIMIT 1
            `
        );

        if (plans.length === 0) {
            throw new Error(
                'Plan entreprise FREE introuvable.'
            );
        }

        return this.baseInsert(
            'company_subscriptions',
            {
                company_id: companyId,
                subscription_plan_id: plans[0].id,

                status: 'ACTIVE',

                started_at: new Date(),
                expires_at: null,
                cancelled_at: null
            }
        );
    }


}
