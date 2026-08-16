import argon2 from 'argon2';

import { AuthenticationError } from '../errors/AuthenticationError.js';
import { AuthorizationError } from '../errors/AuthorizationError.js';

import {
    PlatformUserRepository
} from '../repositories/PlatformUserRepository.js';

import {
    UserRepository
} from '../repositories/UserRepository.js';

export interface PlatformAuthUser {

    userId: string;

    platformUserId: string;

    roleCode: string;

    roleLabel: string;

    firstName: string;

    lastName: string;

    email: string;

}

export class PlatformAuthService {

    private readonly users =
    new UserRepository();

    private readonly platformUsers =
    new PlatformUserRepository();

    public async login(
        email: string,
        password: string
    ): Promise<PlatformAuthUser> {

        const user =
        await this.users.findByEmail(
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

        const validPassword =
        await argon2.verify(
            user.password_hash,
            password
        );

        if (!validPassword) {

            throw new AuthenticationError(
                'Adresse e-mail ou mot de passe incorrect.'
            );

        }

        const platformUser =
        await this.platformUsers.findByUserId(
            user.id
        );

        if (!platformUser) {

            throw new AuthorizationError(
                'Ce compte ne dispose pas d’un accès à l’administration.'
            );

        }

        if (!platformUser.is_active) {

            throw new AuthorizationError(
                'Accès administrateur désactivé.'
            );

        }

        return {

            userId:
            user.id,

            platformUserId:
            platformUser.id,

            roleCode:
            platformUser.role_code,

            roleLabel:
            platformUser.role_label,

            firstName:
            user.firstname,

            lastName:
            user.lastname,

            email:
            user.email

        };

    }

    public async getCurrentUser(
        userId: string
    ): Promise<PlatformAuthUser> {

        const user =
        await this.users.findById(
            userId
        );

        if (!user) {

            throw new AuthenticationError(
                'Utilisateur introuvable.'
            );

        }

        if (!user.is_active) {

            throw new AuthorizationError(
                'Utilisateur désactivé.'
            );

        }

        const platformUser =
        await this.platformUsers.findByUserId(
            userId
        );

        if (!platformUser) {

            throw new AuthorizationError(
                'Ce compte ne dispose pas d’un accès à l’administration.'
            );

        }

        if (!platformUser.is_active) {

            throw new AuthorizationError(
                'Accès administrateur désactivé.'
            );

        }

        return {

            userId:
            user.id,

            platformUserId:
            platformUser.id,

            roleCode:
            platformUser.role_code,

            roleLabel:
            platformUser.role_label,

            firstName:
            user.firstname,

            lastName:
            user.lastname,

            email:
            user.email

        };

    }

}
