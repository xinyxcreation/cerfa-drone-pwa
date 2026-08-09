import { FastifyInstance } from 'fastify';

export default async function healthRoutes(
    app: FastifyInstance
): Promise<void> {

    app.get('/health', async () => {

        const [rows] = await app.db.query<any[]>(`
        SELECT
        UTC_TIMESTAMP(6) AS utc,
                                                 VERSION() AS database_version
                                                 `);

        return {

            success: true,

            api: {

                status: 'running',

            version: '1.0.0'

            },

            database: {

                status: 'connected',

            version: rows[0].database_version

            },

            utc: rows[0].utc

        };

    });

}
