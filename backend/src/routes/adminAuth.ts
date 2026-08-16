import {
    FastifyInstance
} from 'fastify';

import {
    PlatformAuthController
} from '../controllers/PlatformAuthController.js';

export default async function adminAuthRoutes(
    app: FastifyInstance
): Promise<void> {

    const controller =
    new PlatformAuthController();

    app.post(
        '/login',
        controller.login.bind(
            controller
        )
    );

    app.get(
        '/me',
        {
            preHandler: async request => {

                await request.jwtVerify();

            }
        },
        controller.me.bind(
            controller
        )
    );

}
