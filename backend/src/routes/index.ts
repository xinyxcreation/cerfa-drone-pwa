import { FastifyInstance } from 'fastify';

import rootRoutes from './root.js';
import healthRoutes from './health.js';
import authRoutes from './auth.js';

export default async function routes(
    app: FastifyInstance
): Promise<void> {

    await app.register(rootRoutes);

    await app.register(healthRoutes);

    await app.register(authRoutes, {

        prefix: '/auth'

    });

}
