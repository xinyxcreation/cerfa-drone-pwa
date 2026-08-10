import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository.js';

export interface Company extends RowDataPacket {

    id: string;

    name: string;
    legal_name: string | null;
    contact_name: string | null;

    siret: string | null;
    alphatango_operator_number: string;

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
            alphatango_operator_number: string;

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

        return this.baseInsert(
            this.table,
            {
                name: company.name,

                legal_name:
                company.legal_name ?? null,

                contact_name:
                company.contact_name ?? null,

                siret:
                company.siret ?? null,

                alphatango_operator_number:
                company.alphatango_operator_number,

                email:
                company.email ?? null,

                phone:
                company.phone ?? null,

                website_url:
                company.website_url ?? null,

                address_line_1:
                company.address_line_1 ?? null,

                address_line_2:
                company.address_line_2 ?? null,

                postal_code:
                company.postal_code ?? null,

                city:
                company.city ?? null,

                country:
                company.country ?? 'France',

                logo_path:
                company.logo_path ?? null,

                signature_path:
                company.signature_path ?? null,

                is_active: true,

                notes:
                company.notes ?? null
            }
        );

    }
    public async update(
        id: string,
        company: {
            name: string;
            legal_name: string | null;
            contact_name: string | null;

            siret: string | null;
            alphatango_operator_number: string;

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
            {
                name: company.name,

                legal_name:
                company.legal_name,

                contact_name:
                company.contact_name,

                siret:
                company.siret,

                alphatango_operator_number:
                company.alphatango_operator_number,

                email:
                company.email,

                phone:
                company.phone,

                website_url:
                company.website_url,

                address_line_1:
                company.address_line_1,

                address_line_2:
                company.address_line_2,

                postal_code:
                company.postal_code,

                city:
                company.city,

                country:
                company.country,

                notes:
                company.notes
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
