import {
    AuthorizationError
} from '../errors/AuthorizationError.js';

import {
    ConflictError
} from '../errors/ConflictError.js';

import {
    NotFoundError
} from '../errors/NotFoundError.js';

import {
    CompanyRepository
} from '../repositories/CompanyRepository.js';

import {
    UpdateCompanyInput
} from '../schemas/company/UpdateCompanySchema.js';

export class CompanyService {

    private readonly companies =
    new CompanyRepository();

    public async get(
        companyId: string
    ) {

        const company =
        await this.companies.findById(
            companyId
        );

        if (!company) {

            throw new NotFoundError(
                'Entreprise introuvable.'
            );

        }

        return company;

    }

    public async update(
        companyId: string,
        requesterRole: string,
        input: UpdateCompanyInput
    ): Promise<void> {

        if (
            requesterRole !== 'OWNER' &&
            requesterRole !== 'MANAGER'
        ) {

            throw new AuthorizationError(
                'Vous n’avez pas l’autorisation de modifier l’entreprise.'
            );

        }

        const company =
        await this.companies.findById(
            companyId
        );

        if (!company) {

            throw new NotFoundError(
                'Entreprise introuvable.'
            );

        }

        if (!company.is_active) {

            throw new AuthorizationError(
                'Entreprise désactivée.'
            );

        }

        if (
            input.siret &&
            input.siret !== company.siret
        ) {

            // La contrainte UNIQUE de MariaDB
            // protège également cette valeur.
            // On laisse le repository effectuer
            // la validation finale.

        }

        try {

            await this.companies.update(
                companyId,
                {
                    name:
                    input.name,

                    legal_name:
                    input.legal_name ?? null,

                    contact_name:
                    input.contact_name ?? null,

                    siret:
                    input.siret ?? null,

                    alphatango_operator_number:
                    input.alphatango_operator_number,

                    email:
                    input.email ?? null,

                    phone:
                    input.phone ?? null,

                    website_url:
                    input.website_url ?? null,

                    address_line_1:
                    input.address_line_1 ?? null,

                    address_line_2:
                    input.address_line_2 ?? null,

                    postal_code:
                    input.postal_code ?? null,

                    city:
                    input.city ?? null,

                    country:
                    input.country,

                    notes:
                    input.notes ?? null
                }
            );

        } catch (error) {

            const message =
            error instanceof Error
            ? error.message
            : '';

            if (
                message.includes('uq_companies_siret') ||
                message.includes('uq_companies_alphatango')
            ) {

                throw new ConflictError(
                    'Le SIRET ou le numéro AlphaTango est déjà utilisé.'
                );

            }

            throw error;

        }

    }

}
