import {
    NotFoundError
} from '../errors/NotFoundError.js';

import {
    SubscriptionPlanRepository
} from '../repositories/SubscriptionPlanRepository.js';

export class SubscriptionPlanService {

    private readonly plans =
    new SubscriptionPlanRepository();

    public async list() {

        return this.plans.findActive();

    }

    public async updatePlan(
        code: string,
        data: {
            label?: string;
            ads_enabled?: boolean;
            max_users?: number | null;
            is_active?: boolean;
        }
    ) {

        const plan =
        await this.plans.findByCode(
            code
        );

        if (!plan) {

            throw new NotFoundError(
                'Plan d’abonnement introuvable.'
            );

        }

        await this.plans.updatePlan(
            code,
            data
        );

        return this.plans.findByCode(
            code
        );

    }

    public async updatePrice(
        code: string,
        billingPeriod:
            'MONTHLY' |
            'YEARLY',
        amountCents: number,
        currency: string
    ) {

        const plan =
        await this.plans.findByCode(
            code
        );

        if (!plan) {

            throw new NotFoundError(
                'Plan d’abonnement introuvable.'
            );

        }

        const price =
        plan.prices.find(
            item =>
                item.billing_period ===
                billingPeriod
        );

        if (!price) {

            throw new NotFoundError(
                'Tarif d’abonnement introuvable.'
            );

        }

        await this.plans.updatePrice(
            code,
            billingPeriod,
            amountCents,
            currency
        );

        return this.plans.findByCode(
            code
        );

    }

}
