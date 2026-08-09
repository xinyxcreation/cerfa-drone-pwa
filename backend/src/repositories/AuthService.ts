import argon2 from 'argon2';

import { UserRepository } from '../repositories/UserRepository';
import { CompanyRepository } from '../repositories/CompanyRepository';
import { CompanyUserRepository } from '../repositories/CompanyUserRepository';
import { RoleRepository } from '../repositories/RoleRepository';

export interface LoginResult {

    userId: string;

    companyId: string;

    roleCode: string;

}

export class AuthService {

    private readonly users = new UserRepository();

    private readonly companies = new CompanyRepository();

    private readonly companyUsers = new CompanyUserRepository();

    private readonly roles = new RoleRepository();

    public async login(
        email: string,
        password: string
    ): Promise<LoginResult> {

        const user = await this.users.findByEmail(email);

        if (!user) {

            throw new Error('INVALID_CREDENTIALS');

        }

        if (!user.is_active) {

            throw new Error('USER_DISABLED');

        }

        const valid = await argon2.verify(
            user.password_hash,
            password
        );

        if (!valid) {

            throw new Error('INVALID_CREDENTIALS');

        }

        const companies = await this.companyUsers.findByUserId(
            user.id
        );

        if (companies.length === 0) {

            throw new Error('NO_COMPANY');

        }

        const companyUser = companies[0];

        const role = await this.roles.findById(
            companyUser.role_id
        );

        if (!role) {

            throw new Error('ROLE_NOT_FOUND');

        }

        const company = await this.companies.findById(
            companyUser.company_id
        );

        if (!company) {

            throw new Error('COMPANY_NOT_FOUND');

        }

        if (!company.is_active) {

            throw new Error('COMPANY_DISABLED');

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

            roleCode: role.code

        };

    }

}
