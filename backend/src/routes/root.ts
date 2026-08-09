import { FastifyInstance } from 'fastify';

export default async function rootRoutes(
    app: FastifyInstance
): Promise<void> {

    app.get('/', async () => {

        return {

            success: true,

            application: 'CERFA Drone API',

            version: '1.0.0',

            status: 'running'

        };

    });

}
