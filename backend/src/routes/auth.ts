import { FastifyInstance } from 'fastify';

import { AuthController } from '../controllers/AuthController.js';
import { CompanyPilotController } from '../controllers/CompanyPilotController.js';
import { CompanyController } from '../controllers/CompanyController.js';

export default async function authRoutes(
    app: FastifyInstance
): Promise<void> {

    const controller =
    new AuthController();

    const pilotController =
    new CompanyPilotController();

    const companyController =
    new CompanyController();

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
    app.put(
        '/me',
        {
            preHandler: async request => {

                await request.jwtVerify();

            }
        },
        controller.updateMe.bind(controller)
    );
    app.get(
        '/company',
        {
            preHandler: async request => {
                await request.jwtVerify();
            }
        },
        companyController.get.bind(companyController)
    );

    app.put(
        '/company',
        {
            preHandler: async request => {
                await request.jwtVerify();
            }
        },
        companyController.update.bind(companyController)
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
