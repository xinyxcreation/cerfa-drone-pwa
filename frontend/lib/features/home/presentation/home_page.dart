import 'package:flutter/material.dart';

import '../../auth/models/current_user.dart';
import '../../auth/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.user,
    required this.onLogout,
    this.showNavigation = true,
  });

  final CurrentUser user;
  final VoidCallback onLogout;
  final bool showNavigation;

  Future<void> _logout() async {
    await const AuthService().logout();
    onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ============================================================
      // HEADER
      // ============================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text(
          'CERFA DRONE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Déconnexion',
            onPressed: _logout,
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),

      // ============================================================
      // CONTENU
      // ============================================================

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            22,
            16,
            120,
          ),
          children: [

            // --------------------------------------------------------
            // UTILISATEUR / ENTREPRISE
            // --------------------------------------------------------

            Text(
              'Bonjour ${user.firstName} 👋',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                color: Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              user.companyName,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Voici votre tableau de bord',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------------
            // ALERTES
            // --------------------------------------------------------

            _AlertCard(
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------------
            // MISSIONS DU JOUR
            // --------------------------------------------------------

            const _SectionTitle(
              title: 'MISSIONS DU JOUR',
            ),

            const SizedBox(height: 10),

            const _MissionCard(
              time: '10:00',
              title: 'Inspection technique',
              location: 'Châteaubriant (44)',
              status: 'Accepté',
              statusColor: Color(0xFF16A34A),
              statusBackground: Color(0xFFDDF5E5),
            ),

            const SizedBox(height: 10),

            const _MissionCard(
              time: '14:30',
              title: 'Suivi de chantier',
              location: 'Rennes (35)',
              status: 'En attente',
              statusColor: Color(0xFFD97706),
              statusBackground: Color(0xFFFFEDD5),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------------
            // RÉPONSES PRÉFECTURE
            // --------------------------------------------------------

            const _SectionTitle(
              title: 'RÉPONSES PRÉFECTURE',
            ),

            const SizedBox(height: 10),

            _DashboardActionCard(
              icon: Icons.description_outlined,
              title: '1 nouvelle réponse',
              subtitle: "Reçue aujourd'hui",
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------------
            // DOCUMENTS
            // --------------------------------------------------------

            const _SectionTitle(
              title: 'DOCUMENTS',
            ),

            const SizedBox(height: 10),

            _DashboardActionCard(
              icon: Icons.folder_outlined,
              title: '2 documents',
              subtitle: 'Expirent bientôt',
              onTap: () {},
            ),
          ],
        ),
      ),

      // ============================================================
      // NAVIGATION BASSE
      // ============================================================

      bottomNavigationBar: showNavigation
          ? const _BottomNavigation()
          : null,
    );
  }
}

// ==================================================================
// NAVIGATION BASSE
// ==================================================================

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          12,
          0,
          12,
          10,
        ),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.08,
                ),
                blurRadius: 18,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [

              Expanded(
                child: _NavigationItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Accueil',
                  active: true,
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _NavigationItem(
                  icon: Icons.assignment_outlined,
                  activeIcon: Icons.assignment,
                  label: 'Missions',
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _NewMissionButton(
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _NavigationItem(
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  label: 'Statistiques',
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _NavigationItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Gestion',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// ITEM NAVIGATION
// ==================================================================

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  static const Color red = Color(0xFFE30613);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            width: 56,
            height: 30,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFFFFE4E4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              active ? activeIcon : icon,
              size: 22,
              color: active
                  ? red
                  : const Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: active
                  ? red
                  : const Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// BOUTON NOUVELLE MISSION
// ==================================================================

class _NewMissionButton extends StatelessWidget {
  const _NewMissionButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  static const Color red = Color(0xFFE30613);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'Nouvelle',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// TITRE DE SECTION
// ==================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: Color(0xFF333333),
      ),
    );
  }
}

// ==================================================================
// CARTE ALERTES
// ==================================================================

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF171717),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE30613),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      '3 alertes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'nécessitent votre attention',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// CARTE MISSION
// ==================================================================

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.time,
    required this.title,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
  });

  final String time;
  final String title;
  final String location;
  final String status;
  final Color statusColor;
  final Color statusBackground;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            SizedBox(
              width: 54,
              child: Text(
                time,
                style: const TextStyle(
                  color: Color(0xFFE30613),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: statusBackground,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// CARTE ACTION DASHBOARD
// ==================================================================

class _DashboardActionCard extends StatelessWidget {
  const _DashboardActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE30613),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF555555),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
