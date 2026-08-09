import fp from 'fastify-plugin';
import fastifyJwt from '@fastify/jwt';
import { FastifyPluginAsync } from 'fastify';

const jwtPlugin: FastifyPluginAsync = async (fastify) => {

    await fastify.register(fastifyJwt, {

        secret: fastify.config.JWT_SECRET,

        sign: {

            expiresIn: fastify.config.JWT_EXPIRES_IN

        }

    });

};

export default fp(jwtPlugin, {

    name: 'jwt',

    dependencies: ['env']

});
