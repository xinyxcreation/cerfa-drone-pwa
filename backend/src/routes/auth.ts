import { FastifyInstance } from 'fastify';

import { AuthController } from '../controllers/AuthController.js';

export default async function authRoutes(
    app: FastifyInstance
): Promise<void> {

    const controller = new AuthController();

    app.post(
        '/login',
        controller.login.bind(controller)
    );

}
