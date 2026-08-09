import fp from 'fastify-plugin';
import fastifyCors from '@fastify/cors';
import { FastifyPluginAsync } from 'fastify';

const corsPlugin: FastifyPluginAsync = async (fastify) => {
    await fastify.register(fastifyCors, {
        origin: (origin, callback) => {

            // Autoriser les requêtes sans Origin
            // (curl, outils serveur, etc.)
            if (!origin) {
                callback(null, true);
                return;
            }

            try {
                const url = new URL(origin);

                const isLocalhost =
                url.hostname === 'localhost' ||
                url.hostname === '127.0.0.1';

    if (isLocalhost) {
        callback(null, true);
        return;
    }

    callback(
        new Error('Origin non autorisée'),
             false
    );

            } catch {
                callback(
                    new Error('Origin invalide'),
                         false
                );
            }
        },

        methods: [
            'GET',
            'HEAD',
            'POST',
            'PUT',
            'PATCH',
            'DELETE',
            'OPTIONS',
        ],

        allowedHeaders: [
            'Content-Type',
            'Authorization',
        ],

        credentials: true,
    });
};

export default fp(corsPlugin, {
    name: 'cors',
});
