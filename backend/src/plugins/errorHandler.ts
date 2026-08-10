import fp from 'fastify-plugin';

import { ApiError } from '../errors/ApiError.js';

export default fp(async (app) => {

    app.setErrorHandler(
        (error, request, reply) => {

            /*
             * Erreurs applicatives :
             * 400 / 401 / 403 / 404 / 409...
             */
            if (error instanceof ApiError) {

                return reply
                .status(error.statusCode)
                .send({

                    success: false,

                    code: error.code,

                    message: error.message

                });

            }

            /*
             * Fastify/JWT utilise des erreurs dont le code
             * est accessible, mais TypeScript les considère
             * comme unknown.
             */
            const errorCode =
            typeof error === 'object' &&
            error !== null &&
            'code' in error &&
            typeof error.code === 'string'
    ? error.code
    : undefined;

    /*
     * Aucun token.
     */
    if (
        errorCode ===
        'FST_JWT_NO_AUTHORIZATION_IN_HEADER'
    ) {

        return reply
        .status(401)
        .send({

            success: false,

            code: 'UNAUTHORIZED',

            message:
            'Authentification requise.'

        });

    }

    /*
     * Token expiré.
     */
    if (
        errorCode ===
        'FST_JWT_AUTHORIZATION_TOKEN_EXPIRED'
    ) {

        return reply
        .status(401)
        .send({

            success: false,

            code: 'TOKEN_EXPIRED',

            message:
            'Votre session a expiré.'

        });

    }

    /*
     * Token invalide.
     */
    if (
        errorCode ===
        'FST_JWT_AUTHORIZATION_TOKEN_INVALID'
    ) {

        return reply
        .status(401)
        .send({

            success: false,

            code: 'INVALID_TOKEN',

            message:
            'Votre session est invalide.'

        });

    }

    /*
     * Erreur inconnue.
     */
    request.log.error(error);

    return reply
    .status(500)
    .send({

        success: false,

        code: 'INTERNAL_SERVER_ERROR',

        message:
        'Une erreur interne est survenue.'

    });

        }
    );

});
