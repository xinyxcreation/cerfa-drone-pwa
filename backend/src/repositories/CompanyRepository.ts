import { RowDataPacket } from 'mysql2/promise';

import { BaseRepository } from './BaseRepository';

export interface Company extends RowDataPacket {

    id: string;

    name: string;
    siret: string | null;

    email: string | null;
    phone: string | null;

    address_line_1: string | null;
    address_line_2: string | null;

    postal_code: string | null;
    city: string | null;
    country: string | null;

    is_active: boolean;

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
            siret?: string | null;
            email?: string | null;
            phone?: string | null;
            address_line_1?: string | null;
            address_line_2?: string | null;
            postal_code?: string | null;
            city?: string | null;
            country?: string | null;
        }
    ): Promise<string> {

        return this.baseInsert(
            this.table,
            {
                name: company.name,
                siret: company.siret ?? null,
                email: company.email ?? null,
                phone: company.phone ?? null,
                address_line_1: company.address_line_1 ?? null,
                address_line_2: company.address_line_2 ?? null,
                postal_code: company.postal_code ?? null,
                city: company.city ?? null,
                country: company.country ?? 'France',
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
