import {
    FastifyInstance
} from 'fastify';

import {
    AdminSubscriptionController
} from '../controllers/AdminSubscriptionController.js';

export default async function adminSubscriptionRoutes(
    app: FastifyInstance
): Promise<void> {

    const controller =
    new AdminSubscriptionController();

    app.get(
        '/plans',
        controller.plans.bind(
            controller
        )
    );

    app.put(
        '/plans/:code',
        controller.updatePlan.bind(
            controller
        )
    );

    app.put(
        '/plans/:code/prices/:period',
        controller.updatePrice.bind(
            controller
        )
    );

}
