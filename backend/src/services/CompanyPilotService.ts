import argon2 from 'argon2';

import { AuthorizationError } from '../errors/AuthorizationError.js';
import { ConflictError } from '../errors/ConflictError.js';
import { NotFoundError } from '../errors/NotFoundError.js';

import { CompanyRepository } from '../repositories/CompanyRepository.js';
import { CompanyUserRepository } from '../repositories/CompanyUserRepository.js';
import { RoleRepository } from '../repositories/RoleRepository.js';
import { UserRepository } from '../repositories/UserRepository.js';

import {
    CreatePilotInput
} from '../schemas/company/CreatePilotSchema.js';

export interface CreatedPilot {

    id: string;

    email: string;
    firstname: string;
    lastname: string;
    phone: string | null;

    role: string;

}

export class CompanyPilotService {

    private readonly users =
    new UserRepository();

    private readonly companies =
    new CompanyRepository();

    private readonly companyUsers =
    new CompanyUserRepository();

    private readonly roles =
    new RoleRepository();

    public async create(
        companyId: string,
        requesterRole: string,
        input: CreatePilotInput
    ): Promise<CreatedPilot> {

        if (
            requesterRole !== 'OWNER' &&
            requesterRole !== 'MANAGER'
        ) {

            throw new AuthorizationError(
                'Vous n’avez pas l’autorisation de créer un pilote.'
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

        const existingUser =
        await this.users.findByEmail(
            input.email
        );

        if (existingUser) {

            throw new ConflictError(
                'Cette adresse e-mail est déjà utilisée.'
            );

        }

        const role =
        await this.roles.findByCode(
            'PILOT'
        );

        if (!role) {

            throw new NotFoundError(
                'Rôle PILOT introuvable.'
            );

        }

        if (!role.is_active) {

            throw new AuthorizationError(
                'Le rôle PILOT est désactivé.'
            );

        }

        const passwordHash =
        await argon2.hash(
            input.password
        );

        const userId =
        await this.users.create({

            email: input.email,

            password_hash:
            passwordHash,

            firstname:
            input.firstname,

            lastname:
            input.lastname,

            phone:
            input.phone ?? null

        });

        await this.companyUsers.create(
            companyId,
            userId,
            role.id
        );

        return {

            id: userId,

            email: input.email,

            firstname:
            input.firstname,

            lastname:
            input.lastname,

            phone:
            input.phone ?? null,

            role: role.code

        };

    }

    public async deactivate(
        companyId: string,
        requesterRole: string,
        pilotId: string
    ): Promise<void> {

        if (
            requesterRole !== 'OWNER' &&
            requesterRole !== 'MANAGER'
        ) {

            throw new AuthorizationError(
                'Vous n’avez pas l’autorisation de désactiver un pilote.'
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

        const pilots =
        await this.companyUsers
        .findPilotsByCompanyId(
            companyId
        );

        const pilot =
        pilots.find(
            item =>
            item.user_id === pilotId
        );

        if (!pilot) {

            throw new NotFoundError(
                'Pilote introuvable dans cette entreprise.'
            );

        }

        await this.companyUsers.deactivate(
            pilot.id
        );

    }

}
