import 'package:flutter/material.dart';

import '../../auth/models/current_user.dart';
import '../models/company_pilot.dart';
import '../services/pilots_service.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({
    super.key,
    required this.user,
  });

  final CurrentUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: const Text(
            'Gestion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          30,
        ),
        children: [
          _ManagementCard(
            icon: Icons.business_outlined,
            title: 'Entreprise',
            subtitle: user.companyName,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CompanyPage(
                    user: user,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _ManagementCard(
            icon: Icons.person_outline,
            title: 'Pilotes',
            subtitle:
            'Gérer les pilotes de l’entreprise',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PilotsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _ManagementCard(
            icon: Icons.flight_outlined,
            title: 'Drones',
            subtitle:
            'Gérer les drones de l’entreprise',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DronesPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _ManagementCard(
            icon: Icons.location_on_outlined,
            title: 'Sites',
            subtitle:
            'Gérer les sites d’intervention',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SitesPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _ManagementCard(
            icon: Icons.folder_outlined,
            title: 'Documents',
            subtitle:
            'Documents et justificatifs',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DocumentsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _ManagementCard(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            subtitle:
            'Configuration de CERFA DRONE',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// CARTE GESTION
// ==================================================================

class _ManagementCard extends StatelessWidget {
  const _ManagementCard({
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
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E4),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE30613),
                  size: 25,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),

                    const SizedBox(height: 4),

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
                color: Color(0xFF777777),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// ENTREPRISE
// ==================================================================

class CompanyPage extends StatelessWidget {
  const CompanyPage({
    super.key,
    required this.user,
  });

  final CurrentUser user;

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Entreprise',
      icon: Icons.business_outlined,
      children: [
        _InfoCard(
          title: 'Entreprise active',
          value: user.companyName,
        ),

        const SizedBox(height: 12),

        _InfoCard(
          title: 'Rôle',
          value: user.role,
        ),
      ],
    );
  }
}

// ==================================================================
// PILOTES
// ==================================================================

class PilotsPage extends StatefulWidget {
  const PilotsPage({
    super.key,
  });

  @override
  State<PilotsPage> createState() =>
  _PilotsPageState();
}

class _PilotsPageState extends State<PilotsPage> {
  late Future<List<CompanyPilot>> _pilotsFuture;

  @override
  void initState() {
    super.initState();
    _loadPilots();
  }

  void _loadPilots() {
    _pilotsFuture =
    PilotsService.getPilots();
  }

  Future<void> _refresh() async {
    setState(_loadPilots);

    try {
      await _pilotsFuture;
    } catch (_) {}
  }

  Future<void> _openCreatePilot() async {
    final created =
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
        const CreatePilotPage(),
      ),
    );

    if (created == true && mounted) {
      setState(_loadPilots);
    }
  }

  Future<void> _openPilot(
    CompanyPilot pilot,
  ) async {
    final changed =
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
        PilotDetailsPage(
          pilot: pilot,
        ),
      ),
    );

    if (changed == true && mounted) {
      setState(_loadPilots);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Pilotes',
      icon: Icons.person_outline,
      actions: [
        IconButton(
          tooltip: 'Actualiser',
          onPressed: _refresh,
          icon: const Icon(
            Icons.refresh,
          ),
        ),
      ],
      children: [
        FutureBuilder<List<CompanyPilot>>(
          future: _pilotsFuture,
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
              ConnectionState.waiting) {
              return const _PilotLoadingState();
              }

              if (snapshot.hasError) {
                return _PilotErrorState(
                  message: snapshot.error
                  ?.toString()
                  .replaceFirst(
                    'Exception: ',
                    '',
                  ) ??
                  'Impossible de charger les pilotes.',
                  onRetry: () {
                    setState(_loadPilots);
                  },
                );
              }

              final pilots =
              snapshot.data ?? [];

              return Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  _PilotHeader(
                    count: pilots.length,
                    onAdd: _openCreatePilot,
                  ),

                  const SizedBox(height: 16),

                  if (pilots.isEmpty)
                    _EmptyPilotsState(
                      onAdd: _openCreatePilot,
                    )
                    else
                      ...pilots.map(
                        (pilot) => Padding(
                          padding:
                          const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _PilotCard(
                            pilot: pilot,
                            onTap: () =>
                            _openPilot(pilot),
                          ),
                        ),
                      ),
                ],
              );
          },
        ),
      ],
    );
  }
}

// ==================================================================
// HEADER PILOTES
// ==================================================================

class _PilotHeader extends StatelessWidget {
  const _PilotHeader({
    required this.count,
    required this.onAdd,
  });

  final int count;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Équipe de pilotes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                count == 0
                ? 'Aucun pilote'
              : '$count pilote${count > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        FilledButton.icon(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor:
            const Color(0xFFE30613),
            foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
          ),
          icon: const Icon(
            Icons.person_add_outlined,
            size: 19,
          ),
          label: const Text(
            'Ajouter',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// CARTE PILOTE
// ==================================================================

class _PilotCard extends StatelessWidget {
  const _PilotCard({
    required this.pilot,
    required this.onTap,
  });

  final CompanyPilot pilot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFFFE4E4),
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  pilot.initials,
                  style: const TextStyle(
                    color: Color(0xFFE30613),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      pilot.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      pilot.email,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                        Colors.grey.shade600,
                      ),
                    ),

                    if (pilot.phone != null &&
                      pilot.phone!
                      .trim()
                      .isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          pilot.phone!,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                            Colors.grey.shade600,
                          ),
                        ),
                      ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF777777),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// AJOUT PILOTE
// ==================================================================

class CreatePilotPage extends StatefulWidget {
  const CreatePilotPage({
    super.key,
  });

  @override
  State<CreatePilotPage> createState() =>
  _CreatePilotPageState();
}

class _CreatePilotPageState
extends State<CreatePilotPage> {
  final _formKey =
  GlobalKey<FormState>();

  final _firstnameController =
  TextEditingController();

  final _lastnameController =
  TextEditingController();

  final _emailController =
  TextEditingController();

  final _phoneController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!
      .validate()) {
      return;
      }

      setState(() {
        _loading = true;
      });

    try {
      await PilotsService.createPilot(
        firstname:
        _firstnameController.text,
        lastname:
        _lastnameController.text,
        email:
        _emailController.text,
        password:
        _passwordController.text,
        phone:
        _phoneController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(
          content: Text(
            'Pilote créé avec succès.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop(true);

    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          const Color(0xFFB91C1C),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Ajouter un pilote',
      icon: Icons.person_add_outlined,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              _FormField(
                controller:
                _firstnameController,
                label: 'Prénom',
                icon:
                Icons.person_outline,
                enabled: !_loading,
                validator: (value) {
                  if (value == null ||
                    value.trim().isEmpty) {
                    return 'Le prénom est obligatoire.';
                    }

                    return null;
                },
              ),

              const SizedBox(height: 12),

              _FormField(
                controller:
                _lastnameController,
                label: 'Nom',
                icon:
                Icons.person_outline,
                enabled: !_loading,
                validator: (value) {
                  if (value == null ||
                    value.trim().isEmpty) {
                    return 'Le nom est obligatoire.';
                    }

                    return null;
                },
              ),

              const SizedBox(height: 12),

              _FormField(
                controller:
                _emailController,
                label: 'Adresse e-mail',
                icon: Icons.email_outlined,
                keyboardType:
                TextInputType.emailAddress,
                enabled: !_loading,
                validator: (value) {
                  final email =
                  value?.trim() ?? '';

              if (email.isEmpty) {
                return 'L’adresse e-mail est obligatoire.';
              }

              final valid = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              ).hasMatch(email);

              if (!valid) {
                return 'Adresse e-mail invalide.';
              }

              return null;
                },
              ),

              const SizedBox(height: 12),

              _FormField(
                controller:
                _phoneController,
                label: 'Téléphone',
                icon:
                Icons.phone_outlined,
                keyboardType:
                TextInputType.phone,
                enabled: !_loading,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller:
                _passwordController,
                obscureText:
                _obscurePassword,
                enabled: !_loading,
                validator: (value) {
                  if (value == null ||
                    value.isEmpty) {
                    return 'Le mot de passe est obligatoire.';
                    }

                    if (value.length < 8) {
                      return '8 caractères minimum.';
                    }

                    return null;
                },
                decoration:
                _inputDecoration(
                  label: 'Mot de passe initial',
                  icon:
                  Icons.lock_outline,
                  suffixIcon:
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                        !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons
                      .visibility_off_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment:
                Alignment.centerLeft,
                child: Text(
                  'Le pilote pourra utiliser ce mot de passe pour sa première connexion.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                  _loading ? null : _create,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFE30613),
                    foregroundColor:
                      Colors.white,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(13),
                      ),
                  ),
                  child: _loading
                  ? const SizedBox(
                    width: 21,
                    height: 21,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color:
                      Colors.white,
                    ),
                  )
                  : const Text(
                    'Créer le pilote',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// DETAIL PILOTE
// ==================================================================

class PilotDetailsPage extends StatefulWidget {
  const PilotDetailsPage({
    super.key,
    required this.pilot,
  });

  final CompanyPilot pilot;

  @override
  State<PilotDetailsPage> createState() =>
  _PilotDetailsPageState();
}

class _PilotDetailsPageState
extends State<PilotDetailsPage> {
  bool _loading = false;

  Future<void> _deactivate() async {
    final confirmed =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
          const Text('Désactiver le pilote ?'),
          content: Text(
            '${widget.pilot.displayName} ne sera plus associé à l’entreprise.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
              Navigator.of(context)
              .pop(false),
              child:
              const Text('Annuler'),
            ),
            FilledButton(
              style:
              FilledButton.styleFrom(
                backgroundColor:
                const Color(0xFFE30613),
              ),
              onPressed: () =>
              Navigator.of(context)
              .pop(true),
              child:
              const Text('Désactiver'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await PilotsService
      .deactivatePilot(
        widget.pilot.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(
          content: Text(
            'Pilote désactivé.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop(true);

    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
          backgroundColor:
          const Color(0xFFB91C1C),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pilot = widget.pilot;

    return _ManagementSubPage(
      title: 'Pilote',
      icon: Icons.person_outline,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFFFE4E4),
                  borderRadius:
                  BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  pilot.initials,
                  style: const TextStyle(
                    color: Color(0xFFE30613),
                    fontSize: 24,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                pilot.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                pilot.role,
                style: const TextStyle(
                  color:
                  Color(0xFFE30613),
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _InfoCard(
          title: 'Adresse e-mail',
          value: pilot.email,
        ),

        if (pilot.phone != null &&
          pilot.phone!
          .trim()
          .isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Téléphone',
              value: pilot.phone!,
            ),
          ],

          if (pilot.joinedAt != null) ...[
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Membre depuis',
              value:
              _formatDate(pilot.joinedAt!),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
              _loading ? null : _deactivate,
              style:
              OutlinedButton.styleFrom(
                foregroundColor:
                  const Color(0xFFE30613),
                  side: const BorderSide(
                    color:
                    Color(0xFFE30613),
                  ),
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
              ),
              icon: _loading
              ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
              : const Icon(
                Icons.person_off_outlined,
              ),
              label: Text(
                _loading
                ? 'Désactivation...'
              : 'Désactiver le pilote',
              style: const TextStyle(
                fontWeight:
                FontWeight.w700,
              ),
              ),
            ),
          ),
      ],
    );
  }
}

// ==================================================================
// CHAMPS FORMULAIRE
// ==================================================================

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(
        label: label,
        icon: icon,
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(13),
      borderSide: BorderSide.none,
    ),
    enabledBorder:
    OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(13),
      borderSide: BorderSide.none,
    ),
    focusedBorder:
    OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(13),
      borderSide: const BorderSide(
        color: Color(0xFFE30613),
        width: 1.4,
      ),
    ),
    errorBorder:
    OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(13),
      borderSide: const BorderSide(
        color: Color(0xFFDC2626),
      ),
    ),
    focusedErrorBorder:
    OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(13),
      borderSide: const BorderSide(
        color: Color(0xFFDC2626),
        width: 1.4,
      ),
    ),
  );
}

// ==================================================================
// CHARGEMENT
// ==================================================================

class _PilotLoadingState
extends StatelessWidget {
  const _PilotLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE30613),
        ),
      ),
    );
  }
}

// ==================================================================
// ERREUR
// ==================================================================

class _PilotErrorState
extends StatelessWidget {
  const _PilotErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFE30613),
            size: 46,
          ),

          const SizedBox(height: 14),

          const Text(
            'Impossible de charger les pilotes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 18),

          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh,
            ),
            label: const Text(
              'Réessayer',
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// ÉTAT VIDE
// ==================================================================

class _EmptyPilotsState
extends StatelessWidget {
  const _EmptyPilotsState({
    required this.onAdd,
  });

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.person_outline,
            size: 48,
            color: Color(0xFFE30613),
          ),

          const SizedBox(height: 14),

          const Text(
            'Aucun pilote',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Ajoutez le premier pilote de cette entreprise.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 18),

          FilledButton.icon(
            onPressed: onAdd,
            style: FilledButton.styleFrom(
              backgroundColor:
              const Color(0xFFE30613),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.person_add_outlined,
            ),
            label: const Text(
              'Ajouter un pilote',
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// SOUS-PAGE
// ==================================================================

class _ManagementSubPage
extends StatelessWidget {
  const _ManagementSubPage({
    required this.title,
    required this.icon,
    required this.children,
    this.actions,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor:
        const Color(0xFF111111),
        foregroundColor: Colors.white,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: actions,
      ),

      body: ListView(
        padding:
        const EdgeInsets.all(16),
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
              const Color(0xFFFFE4E4),
              borderRadius:
              BorderRadius.circular(17),
            ),
            child: Icon(
              icon,
              color:
              const Color(0xFFE30613),
              size: 30,
            ),
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }
}

// ==================================================================
// INFO
// ==================================================================

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w700,
              color:
              Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// DRONES
// ==================================================================

class DronesPage extends StatelessWidget {
  const DronesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Drones',
      icon: Icons.flight_outlined,
      children: [
        _EmptyManagementState(
          icon: Icons.flight_outlined,
          title: 'Aucun drone chargé',
          message:
          'Les drones de l’entreprise seront affichés ici.',
        ),
      ],
    );
  }
}

// ==================================================================
// SITES
// ==================================================================

class SitesPage extends StatelessWidget {
  const SitesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Sites',
      icon: Icons.location_on_outlined,
      children: [
        _EmptyManagementState(
          icon: Icons.location_on_outlined,
          title: 'Aucun site chargé',
          message:
          'Les sites d’intervention seront affichés ici.',
        ),
      ],
    );
  }
}

// ==================================================================
// DOCUMENTS
// ==================================================================

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Documents',
      icon: Icons.folder_outlined,
      children: [
        _EmptyManagementState(
          icon: Icons.folder_outlined,
          title: 'Aucun document chargé',
          message:
          'Les documents de l’entreprise seront affichés ici.',
        ),
      ],
    );
  }
}

// ==================================================================
// PARAMÈTRES
// ==================================================================

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _ManagementSubPage(
      title: 'Paramètres',
      icon: Icons.settings_outlined,
      children: [
        _EmptyManagementState(
          icon: Icons.settings_outlined,
          title: 'Paramètres',
          message:
          'Les paramètres de l’application seront disponibles ici.',
        ),
      ],
    );
  }
}

// ==================================================================
// ÉTAT VIDE AUTRES SECTIONS
// ==================================================================

class _EmptyManagementState
extends StatelessWidget {
  const _EmptyManagementState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color:
            const Color(0xFFE30613),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color:
              Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day =
  date.day.toString().padLeft(2, '0');

  final month =
  date.month.toString().padLeft(2, '0');

  return '$day/$month/${date.year}';
}
