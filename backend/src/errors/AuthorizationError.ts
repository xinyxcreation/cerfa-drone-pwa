import { ApiError } from './ApiError';

export class AuthorizationError extends ApiError {

    constructor(
        message = 'Accès refusé.'
    ) {

        super(
            403,
            'AUTHORIZATION_ERROR',
            message
        );

    }

}
