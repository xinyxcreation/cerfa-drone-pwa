import fp from 'fastify-plugin';
import { FastifyPluginAsync } from 'fastify';
import { Pool } from 'mysql2/promise';

import {
    getDatabase,
    closeDatabase
} from '../database/core/DatabaseConnection.js';

declare module 'fastify' {

    interface FastifyInstance {

        db: Pool;

    }

}

const databasePlugin: FastifyPluginAsync = async (fastify) => {

    const db = getDatabase();

    fastify.decorate(
        'db',
        db
    );

    fastify.addHook(
        'onClose',
        async () => {

            await closeDatabase();

        }
    );

};

export default fp(databasePlugin, {

    name: 'database'

});
