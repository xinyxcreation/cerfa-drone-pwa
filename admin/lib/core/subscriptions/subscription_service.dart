import '../config/api_config.dart';
import '../network/api_client.dart';
import 'subscription_plan.dart';

class SubscriptionService {

  final ApiClient api;

  SubscriptionService({
    required String token,
  }) : api = ApiClient(
    token: token,
  );


  Future<List<SubscriptionPlan>> loadPlans() async {

    final response =
        await api.get(
      '${ApiConfig.baseUrl}/admin/subscriptions/plans',
    );

    final data =
        response.data;

    const order = [
      'FREE',
      'PREMIUM',
      'FREE_COMPANY',
      'STARTER',
      'PRO',
      'BUSINESS',
    ];

    final plans =
        (data['plans'] as List)
            .map(
              (item) =>
                  SubscriptionPlan.fromJson(
                    item,
                  ),
            )
            .toList();

    plans.sort(
      (a, b) =>
          order.indexOf(a.code)
              .compareTo(
                order.indexOf(b.code),
              ),
    );

    return plans;
  }


  Future<void> savePlan(
    SubscriptionPlan plan,
  ) async {

    await api.put(
      '${ApiConfig.baseUrl}/admin/subscriptions/plans/${plan.code}',
      data: {
        'label':
            plan.label,

        'ads_enabled':
            plan.adsEnabled,

        'max_users':
            plan.maxUsers,

        'is_active':
            plan.isActive,
      },
    );


    final monthly =
        plan.price('MONTHLY');

    await api.put(
      '${ApiConfig.baseUrl}/admin/subscriptions/plans/${plan.code}/prices/MONTHLY',
      data: {
        'amount_cents':
            monthly.amountCents,

        'currency':
            monthly.currency,
      },
    );


    final yearly =
        plan.price('YEARLY');

    await api.put(
      '${ApiConfig.baseUrl}/admin/subscriptions/plans/${plan.code}/prices/YEARLY',
      data: {
        'amount_cents':
            yearly.amountCents,

        'currency':
            yearly.currency,
      },
    );
  }

}
