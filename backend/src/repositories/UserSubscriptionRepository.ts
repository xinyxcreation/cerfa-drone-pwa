import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface UserSubscription extends RowDataPacket {

    id: string;

    user_id: string;
    subscription_plan_id: string;

    status:
        'ACTIVE' |
        'CANCELLED' |
        'EXPIRED' |
        'SUSPENDED';

    started_at: Date;
    expires_at: Date | null;
    cancelled_at: Date | null;

    plan_code: string;
    plan_label: string;
    ads_enabled: boolean;
}

export class UserSubscriptionRepository
extends BaseRepository {

    public async findActiveByUserId(
        userId: string
    ): Promise<UserSubscription | null> {

        const [rows] =
        await this.db.query<UserSubscription[]>(
            `
            SELECT

                us.id,
                us.user_id,
                us.subscription_plan_id,

                us.status,

                us.started_at,
                us.expires_at,
                us.cancelled_at,

                sp.code AS plan_code,
                sp.label AS plan_label,
                sp.ads_enabled

            FROM user_subscriptions us

            INNER JOIN subscription_plans sp
                ON sp.id = us.subscription_plan_id

            WHERE us.user_id = ?

            AND us.status = 'ACTIVE'
            AND us.deleted_at IS NULL

            AND sp.type = 'USER'
            AND sp.is_active = TRUE
            AND sp.deleted_at IS NULL

            AND (
                us.expires_at IS NULL
                OR us.expires_at > UTC_TIMESTAMP(6)
            )

            ORDER BY us.started_at DESC

            LIMIT 1
            `,
            [userId]
        );

        return rows.length > 0
            ? rows[0]
            : null;
    }

    public async createFree(
        userId: string
    ): Promise<string> {

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

        return this.baseInsert(
            'user_subscriptions',
            {
                user_id: userId,
                subscription_plan_id: plans[0].id,

                status: 'ACTIVE',

                started_at: new Date(),
                expires_at: null,
                cancelled_at: null
            }
        );
    }
}
