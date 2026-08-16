class SubscriptionPrice {

  String period;
  int amountCents;
  String currency;

  SubscriptionPrice({
    required this.period,
    required this.amountCents,
    required this.currency,
  });

  factory SubscriptionPrice.fromJson(
      Map<String, dynamic> json) {

    return SubscriptionPrice(
      period:
          json['billing_period'],
      amountCents:
          json['amount_cents'],
      currency:
          json['currency'],
    );

  }

}

class SubscriptionPlan {

  final String id;
  final String code;
  final String type;

  String label;

  bool adsEnabled;

  int? maxUsers;

  bool isActive;

  final List<SubscriptionPrice>
      prices;

  SubscriptionPlan({
    required this.id,
    required this.code,
    required this.type,
    required this.label,
    required this.adsEnabled,
    required this.maxUsers,
    required this.isActive,
    required this.prices,
  });

  factory SubscriptionPlan.fromJson(
      Map<String, dynamic> json) {

    return SubscriptionPlan(
      id:
          json['id'],
      code:
          json['code'],
      type:
          json['type'],
      label:
          json['label'],
      adsEnabled:
          json['ads_enabled'] == true,
      maxUsers:
          json['max_users'],
      isActive:
          json['is_active'] == true,
      prices:
          (json['prices'] as List)
              .map(
                (item) =>
                    SubscriptionPrice
                        .fromJson(
                  item,
                ),
              )
              .toList(),
    );

  }

  SubscriptionPrice price(
      String period) {

    return prices.firstWhere(
      (item) =>
          item.period == period,
    );

  }

}

