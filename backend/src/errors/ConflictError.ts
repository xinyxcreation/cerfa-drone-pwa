import { ApiError } from './ApiError';

export class ConflictError extends ApiError {

    constructor(
        message = 'Conflit.'
    ) {

        super(
            409,
            'CONFLICT',
            message
        );

    }

}
