import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onLogout,
  });

  final VoidCallback onLogout;

  Future<void> _logout() async {
    await const AuthService().logout();

    onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CERFA DRONE',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Bonjour 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Votre session est active.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            const _DashboardCard(
              icon: Icons.assignment_outlined,
              title: 'Missions',
              subtitle: 'Gérer vos missions',
            ),

            const SizedBox(height: 12),

            const _DashboardCard(
              icon: Icons.description_outlined,
              title: 'CERFA',
              subtitle: 'Créer et suivre vos dossiers',
            ),

            const SizedBox(height: 12),

            const _DashboardCard(
              icon: Icons.settings_outlined,
              title: 'Paramètres',
              subtitle: 'Configuration de l’application',
            ),
          ],
        ),
      ),

      // Pas de const ici : compatible avec ta version Flutter.
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Missions',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE30613).withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFFE30613),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
