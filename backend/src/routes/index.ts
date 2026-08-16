import { FastifyInstance } from 'fastify';

import rootRoutes from './root.js';
import healthRoutes from './health.js';
import authRoutes from './auth.js';
import subscriptionRoutes from './subscriptions.js';
import adminAuthRoutes from './adminAuth.js';
import adminSubscriptionRoutes from './adminSubscriptions.js';

export default async function routes(
    app: FastifyInstance
): Promise<void> {

    await app.register(rootRoutes);

    await app.register(healthRoutes);

    await app.register(authRoutes, {

        prefix: '/auth'

    });

    await app.register(subscriptionRoutes, {

        prefix: '/subscriptions'

    });

    await app.register(adminAuthRoutes, {

        prefix: '/admin/auth'

    });

    await app.register(adminSubscriptionRoutes, {

        prefix: '/admin/subscriptions'

    });

}
