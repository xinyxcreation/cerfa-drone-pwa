import {
    FastifyReply,
    FastifyRequest
} from 'fastify';

import {
    PlatformAuthService
} from '../services/PlatformAuthService.js';

import {
    LoginSchema
} from '../schemas/auth/LoginSchema.js';

export class PlatformAuthController {

    private readonly service =
    new PlatformAuthService();

    public async login(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const body =
        LoginSchema.parse(
            request.body
        );

        const auth =
        await this.service.login(
            body.email,
            body.password
        );

        const accessToken =
        await request.server.jwt.sign({

            sub:
            auth.userId,

            platform_user_id:
            auth.platformUserId,

            platform_role:
            auth.roleCode

        });

        reply.send({

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

            platform: {

                id:
                auth.platformUserId,

                role:
                auth.roleCode,

                role_label:
                auth.roleLabel

            }

        });

    }

    public async me(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const payload =
        await request.jwtVerify<{
            sub: string;
            platform_user_id: string;
            platform_role: string;
        }>();

        const auth =
        await this.service.getCurrentUser(
            payload.sub
        );

        reply.send({

            success: true,

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

            platform: {

                id:
                auth.platformUserId,

                role:
                auth.roleCode,

                role_label:
                auth.roleLabel

            }

        });

    }

}
