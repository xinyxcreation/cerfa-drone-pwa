import fp from 'fastify-plugin';

import { ApiError } from '../errors/ApiError';

export default fp(async (app) => {

    app.setErrorHandler((error, request, reply) => {

        if (error instanceof ApiError) {

            return reply
            .status(error.statusCode)
            .send({

                success: false,

                code: error.code,

                message: error.message

            });

        }

        request.log.error(error);

        return reply
        .status(500)
        .send({

            success: false,

            code: 'INTERNAL_SERVER_ERROR',

            message: 'Une erreur interne est survenue.'

        });

    });

});
