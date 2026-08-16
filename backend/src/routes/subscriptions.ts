import {
    FastifyInstance
} from 'fastify';

import {
    SubscriptionController
} from '../controllers/SubscriptionController.js';

export default async function subscriptionRoutes(
    app: FastifyInstance
): Promise<void> {

    const controller =
    new SubscriptionController();

    app.get(
        '/plans',
        controller.plans.bind(
            controller
        )
    );

}
