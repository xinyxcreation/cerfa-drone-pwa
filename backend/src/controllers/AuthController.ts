import {
    FastifyReply,
    FastifyRequest
} from 'fastify';

import { LoginSchema } from '../schemas/auth/LoginSchema.js';
import { RegisterSchema } from '../schemas/auth/RegisterSchema.js';
import { AuthService } from '../services/AuthService.js';
import { UpdateProfileSchema } from '../schemas/auth/UpdateProfileSchema.js';

export class AuthController {

    private readonly authService = new AuthService();

    public async register(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const body =
        RegisterSchema.parse(
            request.body
        );

        const auth =
        await this.authService.register(
            body
        );

        const accessToken =
        await request.server.jwt.sign({

            sub:
            auth.userId,

            company_id:
            auth.companyId,

            role:
            auth.roleCode

        });

        reply.code(201).send({

            success: true,

            access_token:
            accessToken,

            expires_in:
            60 * 60 * 24 * 7,

            user: {

                id:
                auth.userId,

                first_name:
                auth.firstName,

                last_name:
                auth.lastName,

                email:
                auth.email

            },

            company: {

                id:
                auth.companyId,

                name:
                auth.companyName

            },

            role:
            auth.roleCode

        });

    }

    public async login(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const body = LoginSchema.parse(
            request.body
        );

        const auth = await this.authService.login(
            body.email,
            body.password
        );

        const accessToken =
        await request.server.jwt.sign({

            sub: auth.userId,

            company_id: auth.companyId,

            role: auth.roleCode

        });

        reply.send({

            success: true,

            access_token: accessToken,

            expires_in: 60 * 60 * 24 * 7,

            user: {

                id: auth.userId,

                first_name: auth.firstName,

                last_name: auth.lastName,

                email: auth.email

            },

            company: {

                id: auth.companyId,

                name: auth.companyName

            },

            role: auth.roleCode

        });

    }

    public async me(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const payload =
        await request.jwtVerify<{
            sub: string;
            company_id: string;
            role: string;
        }>();

        const result =
        await this.authService.getCurrentUser(
            payload.sub,
            payload.company_id
        );

        reply.send({

            success: true,

            user: {

                id: result.userId,

                first_name: result.firstName,

                last_name: result.lastName,

                email: result.email,

                phone: result.phone,

                is_active: result.isActive

            },

            company: {

                id: result.companyId,

                name: result.companyName

            },

            role: result.roleCode,

            subscription: {

                user:
                result.userPlan
                    ? {
                        code:
                        result.userPlan.code,

                        label:
                        result.userPlan.label,

                        ads_enabled:
                        result.userPlan.adsEnabled
                    }
                    : null,

                company:
                result.companyPlan
                    ? {
                        code:
                        result.companyPlan.code,

                        label:
                        result.companyPlan.label,

                        max_users:
                        result.companyPlan.maxUsers
                    }
                    : null,

                current_users:
                result.currentUsers

            }

        });

    }
    public async updateMe(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const payload =
        await request.jwtVerify<{
            sub: string;
            company_id: string;
            role: string;
        }>();

        const body =
        UpdateProfileSchema.parse(
            request.body
        );

        await this.authService.updateProfile(
            payload.sub,
            {
                first_name: body.first_name,
                last_name: body.last_name,
                email: body.email,
                phone: body.phone ?? null
            }
        );

        const result =
        await this.authService.getCurrentUser(
            payload.sub,
            payload.company_id
        );

        reply.send({

            success: true,

            user: {

                id:
                result.userId,

                first_name:
                result.firstName,

                last_name:
                result.lastName,

                email:
                result.email,

                phone:
                result.phone,

                is_active:
                result.isActive

            }

        });

    }
}
