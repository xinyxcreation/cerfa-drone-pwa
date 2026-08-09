import argon2 from 'argon2';

import { AuthenticationError } from '../errors/AuthenticationError.js';
import { AuthorizationError } from '../errors/AuthorizationError.js';
import { NotFoundError } from '../errors/NotFoundError.js';

import { CompanyRepository } from '../repositories/CompanyRepository.js';
import { CompanyUserRepository } from '../repositories/CompanyUserRepository.js';
import { RoleRepository } from '../repositories/RoleRepository.js';
import { UserRepository } from '../repositories/UserRepository.js';

export interface AuthUser {

    userId: string;

    companyId: string;

    roleId: string;

    roleCode: string;

    firstName: string;

    lastName: string;

    email: string;

    companyName: string;

}

export class AuthService {

    private readonly users = new UserRepository();

    private readonly companies = new CompanyRepository();

    private readonly companyUsers = new CompanyUserRepository();

    private readonly roles = new RoleRepository();

    public async login(
        email: string,
        password: string
    ): Promise<AuthUser> {

        const user = await this.users.findByEmail(
            email.trim().toLowerCase()
        );

        if (!user) {

            throw new AuthenticationError(
                'Adresse e-mail ou mot de passe incorrect.'
            );

        }

        if (!user.is_active) {

            throw new AuthorizationError(
                'Utilisateur désactivé.'
            );

        }

        const validPassword = await argon2.verify(
            user.password_hash,
            password
        );

        if (!validPassword) {

            throw new AuthenticationError(
                'Adresse e-mail ou mot de passe incorrect.'
            );

        }

        const companyUsers =
        await this.companyUsers.findByUserId(
            user.id
        );

        if (companyUsers.length === 0) {

            throw new AuthorizationError(
                'Aucune entreprise associée.'
            );

        }

        const companyUser = companyUsers[0];

        const company =
        await this.companies.findById(
            companyUser.company_id
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

        const role =
        await this.roles.findById(
            companyUser.role_id
        );

        if (!role) {

            throw new NotFoundError(
                'Rôle introuvable.'
            );

        }

        if (!role.is_active) {

            throw new AuthorizationError(
                'Rôle désactivé.'
            );

        }

        await this.users.updateLastLogin(
            user.id
        );

        await this.users.updateLastCompany(
            user.id,
            company.id
        );

        return {

            userId: user.id,

            companyId: company.id,

            roleId: role.id,

            roleCode: role.code,

            firstName: user.first_name,

            lastName: user.last_name,

            email: user.email,

            companyName: company.name

        };

    }

}
