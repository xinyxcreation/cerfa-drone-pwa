import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../core/auth/admin_auth_service.dart';
import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';

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

class SubscriptionsPage
    extends StatefulWidget {

  final AdminAuthService auth;

  const SubscriptionsPage({
    super.key,
    required this.auth,
  });

  @override
  State<SubscriptionsPage> createState() =>
      _SubscriptionsPageState();

}

class _SubscriptionsPageState
    extends State<SubscriptionsPage> {

  List<SubscriptionPlan> plans =
      [];

  bool loading = true;

  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  ApiClient get api =>
      ApiClient(
        token: widget.auth.token,
      );

  Future<void> load() async {

    setState(() {
      loading = true;
      error = null;
    });

    try {

      final response =
          await api.get(
        '${ApiConfig.baseUrl}/admin/subscriptions/plans',
      );

      final data =
          response.data;

      plans =
          (data['plans'] as List)
              .map(
                (item) =>
                    SubscriptionPlan
                        .fromJson(
                  item,
                ),
              )
              .toList();

      const order = [
        'FREE',
        'PREMIUM',
        'FREE_COMPANY',
        'STARTER',
        'PRO',
        'BUSINESS',
      ];

      plans.sort(
        (a, b) =>
            order.indexOf(a.code)
                .compareTo(
                  order.indexOf(b.code),
                ),
      );

    } on DioException catch (e) {

      error =
          e.response?.data?['message'] ??
              'Erreur de chargement.';

    } catch (_) {

      error =
          'Erreur de chargement.';

    }

    if (mounted) {

      setState(() {
        loading = false;
      });

    }

  }

  Future<void> savePlan(
      SubscriptionPlan plan) async {

    try {

      await api.put(
        '${ApiConfig.baseUrl}/admin/subscriptions/plans/${plan.code}',
        data: {
          'label': plan.label,
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

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text(
              'Plan enregistré.',
            ),
          ),
        );

      }

    } catch (_) {

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text(
              'Erreur lors de l’enregistrement.',
            ),
          ),
        );

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Center(
        child:
            CircularProgressIndicator(),
      );

    }

    if (error != null) {

      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [

            Text(error!),

            const SizedBox(
              height: 16,
            ),

            FilledButton(
              onPressed: load,
              child:
                  const Text(
                'Réessayer',
              ),
            ),

          ],
        ),
      );

    }

    return RefreshIndicator(
      onRefresh: load,

      child: ListView(
        padding:
            const EdgeInsets.all(32),

        children: [

          const Text(
            'Gestion des abonnements',
            style: TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          const Text(
            'Les tarifs et limites sont configurables depuis cette interface.',
          ),

          const SizedBox(
            height: 32,
          ),

          ...plans.map(
            (plan) =>
                _PlanCard(
              plan: plan,
              editable:
                  widget.auth.isAdmin,
              onSavePlan:
                  () => savePlan(plan),

            ),
          ),

        ],
      ),
    );

  }

}

class _PlanCard extends StatefulWidget {

  final SubscriptionPlan plan;

  final bool editable;

  final VoidCallback onSavePlan;

  const _PlanCard({
    required this.plan,
    required this.editable,
    required this.onSavePlan,  });

  @override
  State<_PlanCard> createState() =>
      _PlanCardState();

}

class _PlanCardState
    extends State<_PlanCard> {

  late TextEditingController
      labelController;

  late TextEditingController
      maxUsersController;

  late TextEditingController
      monthlyController;

  late TextEditingController
      yearlyController;

  @override
  void initState() {

    super.initState();

    labelController =
        TextEditingController(
      text: widget.plan.label,
    );

    maxUsersController =
        TextEditingController(
      text:
          widget.plan.maxUsers?.toString() ??
              '',
    );

    monthlyController =
        TextEditingController(
      text:
          _euros(
        widget.plan
            .price('MONTHLY')
            .amountCents,
      ),
    );

    yearlyController =
        TextEditingController(
      text:
          _euros(
        widget.plan
            .price('YEARLY')
            .amountCents,
      ),
    );

  }

  String _euros(int cents) {

    return (cents / 100)
        .toStringAsFixed(2);

  }

  @override
  void dispose() {

    labelController.dispose();
    maxUsersController.dispose();
    monthlyController.dispose();
    yearlyController.dispose();

    super.dispose();
  }

  int _cents(
      String value) {

    final parsed =
        double.tryParse(
      value.replaceAll(
        ',',
        '.',
      ),
    );

    if (parsed == null) {
      return 0;
    }

    return (parsed * 100)
        .round();

  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    widget.plan.code,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                Chip(
                  label:
                      Text(
                    widget.plan.type,
                  ),
                ),

              ],
            ),

            const SizedBox(
              height: 20,
            ),

            if (widget.plan.type == 'COMPANY')
              Text(
                '${widget.plan.maxUsers ?? 0} utilisateur${widget.plan.maxUsers == 1 ? '' : 's'} maximum',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  labelController,
              enabled:
                  widget.editable,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nom du plan',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [

                if (widget.plan.type == 'COMPANY')
                  Expanded(
                    child:
                        TextField(
                      controller:
                          maxUsersController,
                      enabled:
                          widget.editable,
                      keyboardType:
                          TextInputType.number,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Nombre d'utilisateurs maximum",
                      ),
                    ),
                  ),

                const SizedBox(
                  width: 16,
                ),

                Expanded(
                  child: SwitchListTile(
                    title:
                        const Text(
                      'Publicité',
                    ),
                    value:
                        widget.plan
                            .adsEnabled,
                    onChanged:
                        widget.editable
                            ? (value) {
                                setState(() {
                                  widget.plan
                                      .adsEnabled =
                                      value;
                                });
                              }
                            : null,
                  ),
                ),

                Expanded(
                  child: SwitchListTile(
                    title:
                        const Text(
                      'Actif',
                    ),
                    value:
                        widget.plan
                            .isActive,
                    onChanged:
                        widget.editable
                            ? (value) {
                                setState(() {
                                  widget.plan
                                      .isActive =
                                      value;
                                });
                              }
                            : null,
                  ),
                ),

              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              children: [

                Expanded(
                  child:
                      TextField(
                    controller:
                        monthlyController,
                    enabled:
                        widget.editable,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Mensuel (€)',
                    ),
                  ),
                ),

                const SizedBox(
                  width: 16,
                ),

                Expanded(
                  child:
                      TextField(
                    controller:
                        yearlyController,
                    enabled:
                        widget.editable,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Annuel (€)',
                    ),
                  ),
                ),

              ],
            ),

            if (widget.editable) ...[

              const SizedBox(
                height: 20,
              ),

              Wrap(
                spacing: 12,
                runSpacing: 12,

                children: [

                  FilledButton.icon(
                    onPressed: () {

                      final maxUsers =
                          int.tryParse(
                        maxUsersController
                            .text,
                      );

                      widget.plan.label =
                          labelController.text
                              .trim();

                      widget.plan.maxUsers =
                          widget.plan.type ==
                                  'COMPANY'
                              ? maxUsers
                              : null;

                      widget.plan.price('MONTHLY')
                          .amountCents =
                          _cents(
                            monthlyController.text,
                          );

                      widget.plan.price('YEARLY')
                          .amountCents =
                          _cents(
                            yearlyController.text,
                          );

                      widget.onSavePlan();

                    },
                    icon:
                        const Icon(
                      Icons.save,
                    ),
                    label:
                        const Text(
                      'Enregistrer le plan',
                    ),
                  ),

                ],

              ),

            ],

          ],
        ),
      ),
    );

  }

}
