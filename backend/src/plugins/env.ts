import fp from 'fastify-plugin';
import { FastifyPluginAsync } from 'fastify';
import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const schema = z.object({

    NODE_ENV: z
    .enum([
        'development',
        'production',
        'test'
    ])
    .default('development'),

                        HOST: z.string().default('127.0.0.1'),

                        PORT: z.coerce.number().default(3000),

                        DB_HOST: z.string(),

                        DB_PORT: z.coerce.number(),

                        DB_NAME: z.string(),

                        DB_USER: z.string(),

                        DB_PASSWORD: z.string(),

                        JWT_SECRET: z.string().min(32),

                        JWT_EXPIRES_IN: z.string().default('7d')

});

export type AppConfig = z.infer<typeof schema>;

declare module 'fastify' {

    interface FastifyInstance {

        config: AppConfig;

    }

}

const envPlugin: FastifyPluginAsync = async (fastify) => {

    fastify.decorate(
        'config',
        schema.parse(process.env)
    );

};

export default fp(envPlugin, {

    name: 'env'

});
