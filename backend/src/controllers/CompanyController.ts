import {
    FastifyReply,
    FastifyRequest
} from 'fastify';

import {
    AuthorizationError
} from '../errors/AuthorizationError.js';

import {
    UpdateCompanySchema
} from '../schemas/company/UpdateCompanySchema.js';

import {
    CompanyService
} from '../services/CompanyService.js';

interface AuthPayload {
    sub: string;
    company_id: string;
    role: string;
}

export class CompanyController {

    private readonly service =
    new CompanyService();

    public async get(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const payload =
        await request.jwtVerify<AuthPayload>();

        if (!payload.company_id) {
            throw new AuthorizationError(
                'Entreprise introuvable dans la session.'
            );
        }

        /*
         * La gestion de l'entreprise est réservée
         * au propriétaire et aux gestionnaires.
         */
        if (
            payload.role !== 'OWNER' &&
            payload.role !== 'MANAGER'
        ) {
            throw new AuthorizationError(
                'Vous n’avez pas l’autorisation d’accéder aux informations de l’entreprise.'
            );
        }

        const company =
        await this.service.get(
            payload.company_id
        );

        reply.send({

            success: true,

            company: {

                id: company.id,

                name: company.name,

                legal_name: company.legal_name,

                contact_name: company.contact_name,

                siret: company.siret,

                alphatango_operator_number:
                company.alphatango_operator_number,

                email: company.email,

                phone: company.phone,

                website_url: company.website_url,

                address_line_1:
                company.address_line_1,

                address_line_2:
                company.address_line_2,

                postal_code: company.postal_code,

                city: company.city,

                country: company.country,

                logo_path: company.logo_path,

                signature_path:
                company.signature_path,

                is_active: company.is_active,

                notes: company.notes,

                created_at: company.created_at,

                updated_at: company.updated_at

            }

        });

    }

    public async update(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const payload =
        await request.jwtVerify<AuthPayload>();

        if (!payload.company_id) {
            throw new AuthorizationError(
                'Entreprise introuvable dans la session.'
            );
        }

        /*
         * Seuls OWNER et MANAGER peuvent
         * modifier les informations de l'entreprise.
         */
        if (
            payload.role !== 'OWNER' &&
            payload.role !== 'MANAGER'
        ) {
            throw new AuthorizationError(
                'Vous n’avez pas l’autorisation de modifier l’entreprise.'
            );
        }

        const body =
        UpdateCompanySchema.parse(
            request.body
        );

        await this.service.update(
            payload.company_id,
            payload.role,
            body
        );

        const company =
        await this.service.get(
            payload.company_id
        );

        reply.send({

            success: true,

            company: {

                id: company.id,

                name: company.name,

                legal_name: company.legal_name,

                contact_name: company.contact_name,

                siret: company.siret,

                alphatango_operator_number:
                company.alphatango_operator_number,

                email: company.email,

                phone: company.phone,

                website_url: company.website_url,

                address_line_1:
                company.address_line_1,

                address_line_2:
                company.address_line_2,

                postal_code: company.postal_code,

                city: company.city,

                country: company.country,

                logo_path: company.logo_path,

                signature_path:
                company.signature_path,

                is_active: company.is_active,

                notes: company.notes

            }

        });

    }

}
