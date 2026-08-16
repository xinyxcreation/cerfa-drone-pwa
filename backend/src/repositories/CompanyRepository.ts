import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';
import {
    CompanySubscriptionRepository
} from './CompanySubscriptionRepository.js';

export interface Company extends RowDataPacket {
    id: string;

    name: string;
    legal_name: string | null;
    contact_name: string | null;

    siret: string | null;
    alphatango_operator_number: string | null;

    email: string | null;
    phone: string | null;
    website_url: string | null;

    address_line_1: string | null;
    address_line_2: string | null;

    postal_code: string | null;
    city: string | null;
    country: string;

    logo_path: string | null;
    signature_path: string | null;

    is_active: boolean;
    notes: string | null;

    created_at: Date;
    updated_at: Date;
    deleted_at: Date | null;

    sync_cursor: number;
}

export class CompanyRepository extends BaseRepository {

    private readonly table = 'companies';

    private readonly subscriptions =
    new CompanySubscriptionRepository();

    public async findById(
        id: string
    ): Promise<Company | null> {

        return this.baseFindById<Company>(
            this.table,
            id
        );
    }

    public async create(
        company: {
            name: string;
            legal_name?: string | null;
            contact_name?: string | null;
            siret?: string | null;
            alphatango_operator_number?: string | null;
            email?: string | null;
            phone?: string | null;
            website_url?: string | null;
            address_line_1?: string | null;
            address_line_2?: string | null;
            postal_code?: string | null;
            city?: string | null;
            country?: string;
            logo_path?: string | null;
            signature_path?: string | null;
            notes?: string | null;
        }
    ): Promise<string> {

        const companyId =
        await this.baseInsert(
            this.table,
            {
                name: company.name,
                legal_name: company.legal_name ?? null,
                contact_name: company.contact_name ?? null,
                siret: company.siret ?? null,
                alphatango_operator_number:
                    company.alphatango_operator_number ?? null,
                email: company.email ?? null,
                phone: company.phone ?? null,
                website_url: company.website_url ?? null,
                address_line_1: company.address_line_1 ?? null,
                address_line_2: company.address_line_2 ?? null,
                postal_code: company.postal_code ?? null,
                city: company.city ?? null,
                country: company.country ?? 'France',
                logo_path: company.logo_path ?? null,
                signature_path: company.signature_path ?? null,
                is_active: true,
                notes: company.notes ?? null
            }
        );

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

        await this.db.execute(
            `
            INSERT INTO company_subscriptions (
                id,
                company_id,
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
                companyId,
                plans[0].id
            ]
        );

        return companyId;
    }

    public async update(
        id: string,
        company: {
            name: string;
            legal_name: string | null;
            contact_name: string | null;
            siret: string | null;
            alphatango_operator_number: string | null;
            email: string | null;
            phone: string | null;
            website_url: string | null;
            address_line_1: string | null;
            address_line_2: string | null;
            postal_code: string | null;
            city: string | null;
            country: string;
            notes: string | null;
        }
    ): Promise<void> {

        await this.baseUpdate(
            this.table,
            id,
            company
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
