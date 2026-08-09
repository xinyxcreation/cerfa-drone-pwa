import { FastifyInstance } from 'fastify';

import { AuthController } from '../controllers/AuthController.js';
import { CompanyPilotController } from '../controllers/CompanyPilotController.js';

export default async function authRoutes(
    app: FastifyInstance
): Promise<void> {

    const controller =
    new AuthController();

    const pilotController =
    new CompanyPilotController();

    app.post(
        '/login',
        controller.login.bind(controller)
    );

    app.get(
        '/me',
        {
            preHandler: async request => {

                await request.jwtVerify();

            }
        },
        controller.me.bind(controller)
    );

    app.get(
        '/company/pilots',
        {
            preHandler: async request => {

                await request.jwtVerify();

            }
        },
        pilotController.list.bind(
            pilotController
        )
    );

    app.post(
        '/company/pilots',
        {
            preHandler: async request => {

                await request.jwtVerify();

            }
        },
        pilotController.create.bind(
            pilotController
        )
    );
    app.delete(
        '/company/pilots/:pilotId',
        {
            preHandler: async request => {
                await request.jwtVerify();
            }
        },
        pilotController.deactivate.bind(
            pilotController
        )
    );

}
