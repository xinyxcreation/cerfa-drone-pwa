import {
    RowDataPacket
} from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface SubscriptionPlanPrice {
    billing_period:
        'MONTHLY' |
        'YEARLY';

    amount_cents:
        number;

    currency:
        string;
}

export interface SubscriptionPlan {
    id: string;
    code: string;
    type: 'USER' | 'COMPANY';
    label: string;
    description: string | null;
    price_cents: number;
    ads_enabled: boolean;
    max_users: number | null;
    is_active: boolean;
    prices: SubscriptionPlanPrice[];
}

interface SubscriptionPlanRow extends RowDataPacket {
    id: string;
    code: string;
    type: 'USER' | 'COMPANY';
    label: string;
    price_cents: number;
    ads_enabled: number;
    max_users: number | null;
    is_active: number;

    billing_period: 'MONTHLY' | 'YEARLY';
    amount_cents: number;
    currency: string;
}

export class SubscriptionPlanRepository
    extends BaseRepository {

    public async findActive(): Promise<SubscriptionPlan[]> {

        const [rows] =
        await this.db.query<SubscriptionPlanRow[]>(`
            SELECT
                sp.id,
                sp.code,
                sp.type,
                sp.label,
                sp.price_cents,
                sp.ads_enabled,
                sp.max_users,
                sp.is_active,

                spp.billing_period,
                spp.amount_cents,
                spp.currency

            FROM subscription_plans sp

            LEFT JOIN subscription_prices spp
                ON spp.subscription_plan_id = sp.id
                AND spp.deleted_at IS NULL
                AND spp.is_active = TRUE

            WHERE sp.is_active = TRUE
              AND sp.deleted_at IS NULL

            ORDER BY
                sp.type,
                sp.max_users IS NULL,
                sp.max_users,
                sp.code,
                spp.billing_period
        `);

        return this.groupRows(rows);
    }

    public async findByCode(
        code: string
    ): Promise<SubscriptionPlan | null> {

        const [rows] =
        await this.db.query<SubscriptionPlanRow[]>(`
            SELECT
                sp.id,
                sp.code,
                sp.type,
                sp.label,
                sp.price_cents,
                sp.ads_enabled,
                sp.max_users,
                sp.is_active,

                spp.billing_period,
                spp.amount_cents,
                spp.currency

            FROM subscription_plans sp

            LEFT JOIN subscription_prices spp
                ON spp.subscription_plan_id = sp.id
                AND spp.deleted_at IS NULL
                AND spp.is_active = TRUE

            WHERE sp.code = ?
              AND sp.deleted_at IS NULL

            ORDER BY spp.billing_period
        `, [code]);

        if (rows.length === 0) {
            return null;
        }

        return this.groupRows(rows)[0] ?? null;
    }

    public async updatePlan(
        code: string,
        data: {
            label?: string;
            ads_enabled?: boolean;
            max_users?: number | null;
            is_active?: boolean;
        }
    ): Promise<void> {

        const fields: string[] = [];
        const values: unknown[] = [];

        if (data.label !== undefined) {
            fields.push('label = ?');
            values.push(data.label);
        }

        if (data.ads_enabled !== undefined) {
            fields.push('ads_enabled = ?');
            values.push(data.ads_enabled);
        }

        if (data.max_users !== undefined) {
            fields.push('max_users = ?');
            values.push(data.max_users);
        }

        if (data.is_active !== undefined) {
            fields.push('is_active = ?');
            values.push(data.is_active);
        }

        if (fields.length === 0) {
            return;
        }

        fields.push(
            'updated_at = UTC_TIMESTAMP(6)'
        );

        values.push(code);

        await this.db.query(`
            UPDATE subscription_plans
            SET
                ${fields.join(', ')}

            WHERE code = ?
              AND deleted_at IS NULL
        `, values);
    }

    public async updatePrice(
        code: string,
        billingPeriod: 'MONTHLY' | 'YEARLY',
        amountCents: number,
        currency: string
    ): Promise<void> {

        await this.db.query(`
            UPDATE subscription_prices spp

            INNER JOIN subscription_plans sp
                ON sp.id = spp.subscription_plan_id

            SET
                spp.amount_cents = ?,
                spp.currency = ?,
                spp.updated_at = UTC_TIMESTAMP(6)

            WHERE sp.code = ?
              AND spp.billing_period = ?
              AND spp.deleted_at IS NULL
        `, [
            amountCents,
            currency,
            code,
            billingPeriod
        ]);
    }

    private groupRows(
        rows: SubscriptionPlanRow[]
    ): SubscriptionPlan[] {

        const plans =
        new Map<string, SubscriptionPlan>();

        for (const row of rows) {

            let plan = plans.get(row.id);

            if (!plan) {

                plan = {
                    id: row.id,
                    code: row.code,
                    type: row.type,
                    label: row.label,
                    description: null,
                    price_cents: row.price_cents,
                    ads_enabled: Boolean(row.ads_enabled),
                    max_users: row.max_users,
                    is_active: Boolean(row.is_active),
                    prices: []
                };

                plans.set(row.id, plan);
            }

            if (row.billing_period) {

                plan.prices.push({
                    billing_period: row.billing_period,
                    amount_cents: row.amount_cents,
                    currency: row.currency
                });
            }
        }

        return Array.from(plans.values());
    }
}
