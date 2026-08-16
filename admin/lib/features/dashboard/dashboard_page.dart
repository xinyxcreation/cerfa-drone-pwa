import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../subscriptions/subscriptions_page.dart';

class DashboardPage extends StatefulWidget {

  final AdminAuthService auth;

  const DashboardPage({
    super.key,
    required this.auth,
  });

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();

}

class _DashboardPageState
    extends State<DashboardPage> {

  int selected = 0;

  @override
  Widget build(BuildContext context) {

    final pages = <Widget>[

      const _HomePage(),

      SubscriptionsPage(
        auth: widget.auth,
      ),

    ];

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          'CERFA Drone Administration',
        ),

        actions: [

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            child: Center(
              child: Text(
                widget.auth.role ??
                    '',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.auth.logout();

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => _LoginRedirect(
                    auth: widget.auth,
                  ),
                ),
                (_) => false,
              );
            },
          ),

        ],
      ),

      body: Row(

        children: [

          NavigationRail(

            selectedIndex:
                selected,

            onDestinationSelected:
                (index) {

              setState(() {
                selected = index;
              });

            },

            labelType:
                NavigationRailLabelType.all,

            destinations: const [

              NavigationRailDestination(
                icon:
                    Icon(
                  Icons.dashboard_outlined,
                ),
                selectedIcon:
                    Icon(
                  Icons.dashboard,
                ),
                label:
                    Text(
                  'Tableau de bord',
                ),
              ),

              NavigationRailDestination(
                icon:
                    Icon(
                  Icons.payments_outlined,
                ),
                selectedIcon:
                    Icon(
                  Icons.payments,
                ),
                label:
                    Text(
                  'Abonnements',
                ),
              ),

            ],
          ),

          const VerticalDivider(
            width: 1,
          ),

          Expanded(
            child:
                pages[selected],
          ),

        ],
      ),
    );

  }

}

class _HomePage extends StatelessWidget {

  const _HomePage();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
          const EdgeInsets.all(32),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: const [

          Text(
            'Tableau de bord',
            style: TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 8,
          ),

          Text(
            'Administration de CERFA Drone',
          ),

        ],
      ),
    );

  }

}

class _LoginRedirect
    extends StatelessWidget {

  final AdminAuthService auth;

  const _LoginRedirect({
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {

    // Import local évité ici pour garder
    // le dashboard simple.
    return const Scaffold(
      body: Center(
        child: Text(
          'Session terminée. Rechargez la page.',
        ),
      ),
    );

  }

}
