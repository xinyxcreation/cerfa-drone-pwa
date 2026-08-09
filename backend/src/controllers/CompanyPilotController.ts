import {
    FastifyReply,
    FastifyRequest
} from 'fastify';

import { CreatePilotSchema } from '../schemas/company/CreatePilotSchema.js';
import { CompanyPilotService } from '../services/CompanyPilotService.js';

import { CompanyUserRepository } from '../repositories/CompanyUserRepository.js';
import { AuthorizationError } from '../errors/AuthorizationError.js';

interface AuthPayload {

    sub: string;
    company_id: string;
    role: string;

}

export class CompanyPilotController {

    private readonly companyUsers =
    new CompanyUserRepository();

    private readonly service =
    new CompanyPilotService();

    public async list(
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

        const pilots =
        await this.companyUsers.findPilotsByCompanyId(
            payload.company_id
        );

        reply.send({

            success: true,

            pilots: pilots.map(pilot => ({

                id: pilot.user_id,

                email: pilot.email,

                first_name:
                pilot.firstname,

                last_name:
                pilot.lastname,

                phone:
                pilot.phone,

                joined_at:
                pilot.joined_at,

                role:
                pilot.role_code

            }))

        });

    }

    public async create(
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

        const body =
        CreatePilotSchema.parse(
            request.body
        );

        const pilot =
        await this.service.create(

            payload.company_id,

            payload.role,

            body

        );

        reply.code(201).send({

            success: true,

            pilot: {

                id:
                pilot.id,

                email:
                pilot.email,

                first_name:
                pilot.firstname,

                last_name:
                pilot.lastname,

                phone:
                pilot.phone,

                role:
                pilot.role

            }

        });

    }
    public async deactivate(
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

        const params =
        request.params as {
            pilotId: string;
        };

        await this.service.deactivate(
            payload.company_id,
            payload.role,
            params.pilotId
        );

        reply.send({
            success: true
        });
    }
}
