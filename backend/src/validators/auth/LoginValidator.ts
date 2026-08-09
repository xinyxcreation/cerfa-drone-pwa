export interface LoginRequest {

    email: string;

    password: string;

}

export class LoginValidator {

    public validate(
        body: unknown
    ): LoginRequest {

        if (typeof body !== 'object' || body === null) {

            throw new Error('INVALID_BODY');

        }

        const data = body as Record<string, unknown>;

        if (
            typeof data.email !== 'string'
            || data.email.trim() === ''
        ) {

            throw new Error('INVALID_EMAIL');

        }

        if (
            typeof data.password !== 'string'
        || data.password.length < 8
        ) {

            throw new Error('INVALID_PASSWORD');

        }

        return {

            email: data.email.trim().toLowerCase(),

            password: data.password

        };

    }

}
