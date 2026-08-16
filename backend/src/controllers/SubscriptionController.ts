import {
    FastifyReply,
    FastifyRequest
} from 'fastify';

import {
    SubscriptionPlanService
} from '../services/SubscriptionPlanService.js';

export class SubscriptionController {

    private readonly service =
    new SubscriptionPlanService();

    public async plans(
        _request: FastifyRequest,
        reply: FastifyReply
    ): Promise<void> {

        const plans =
        await this.service.list();

        reply.send({

            success: true,

            plans:
            plans.map(plan => ({

                code:
                plan.code,

                type:
                plan.type,

                label:
                plan.label,

                ads_enabled:
                plan.ads_enabled,

                max_users:
                plan.max_users,

                prices:
                plan.prices.map(price => ({

                    billing_period:
                    price.billing_period,

                    amount_cents:
                    price.amount_cents,

                    currency:
                    price.currency

                }))

            }))

        });

    }

}
