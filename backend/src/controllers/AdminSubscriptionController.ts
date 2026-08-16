import {
    FastifyReply,
    FastifyRequest
} from 'fastify';

import {
    AuthorizationError
} from '../errors/AuthorizationError.js';

import {
    SubscriptionPlanService
} from '../services/SubscriptionPlanService.js';

export class AdminSubscriptionController {

    private readonly service =
    new SubscriptionPlanService();

    private async requireAdmin(
        request: FastifyRequest
    ): Promise<void> {

        const payload =
        await request.jwtVerify<{
            sub: string;
            platform_user_id: string;
            platform_role: string;
        }>();

        if (
            payload.platform_role !== 'ADMIN'
        ) {

            throw new AuthorizationError(
                'Droits administrateur requis.'
            );

        }

    }

    public async plans(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const payload =
        await request.jwtVerify<{
            sub: string;
            platform_user_id: string;
            platform_role: string;
        }>();

        if (
            payload.platform_role !== 'ADMIN' &&
            payload.platform_role !== 'MODERATOR'
        ) {

            throw new AuthorizationError(
                'Accès administration refusé.'
            );

        }

        const plans =
        await this.service.list();

        reply.send({
            success: true,
            plans
        });

    }

    public async updatePlan(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        await this.requireAdmin(
            request
        );

        const params =
        request.params as {
            code: string;
        };

        const body =
        request.body as {
            label?: string;
            ads_enabled?: boolean;
            max_users?: number | null;
            is_active?: boolean;
        };

        if (
            body.label !== undefined &&
            (
                typeof body.label !== 'string' ||
                body.label.trim().length === 0
            )
        ) {

            throw new AuthorizationError(
                'Nom de plan invalide.'
            );

        }

        if (
            body.max_users !== undefined &&
            body.max_users !== null &&
            (
                !Number.isInteger(
                    body.max_users
                ) ||
                body.max_users < 1
            )
        ) {

            throw new AuthorizationError(
                "Nombre d'utilisateurs invalide."
            );

        }

        const plan =
        await this.service.updatePlan(
            params.code,
            body
        );

        reply.send({
            success: true,
            plan
        });

    }

    public async updatePrice(
        request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        await this.requireAdmin(
            request
        );

        const params =
        request.params as {
            code: string;
            period: string;
        };

        const body =
        request.body as {
            amount_cents?: number;
            currency?: string;
        };

        const period =
        params.period.toUpperCase();

        if (
            period !== 'MONTHLY' &&
            period !== 'YEARLY'
        ) {

            throw new AuthorizationError(
                'Période invalide.'
            );

        }

        const amountCents =
            body.amount_cents;

        if (
            amountCents === undefined ||
            !Number.isInteger(
                amountCents
            ) ||
            amountCents < 0
        ) {

            throw new AuthorizationError(
                'Montant invalide.'
            );

        }

        const currency =
        (
            body.currency ??
            'EUR'
        ).toUpperCase();

        if (
            !/^[A-Z]{3}$/.test(
                currency
            )
        ) {

            throw new AuthorizationError(
                'Devise invalide.'
            );

        }

        const plan =
        await this.service.updatePrice(
            params.code,
            period as 'MONTHLY' | 'YEARLY',
            amountCents,
            currency
        );

        reply.send({
            success: true,
            plan
        });

    }

}
