import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() =>
  _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile =
      await ProfileService.getProfile();

      if (!mounted) {
        return;
      }

      setState(() {
        _firstNameController.text =
        profile.firstName;

        _lastNameController.text =
        profile.lastName;

        _emailController.text =
        profile.email;

        _phoneController.text =
        profile.phone ?? '';

      _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });

      _showMessage(
        error.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        isError: true,
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await ProfileService.updateProfile(
        firstName:
        _firstNameController.text,
        lastName:
        _lastNameController.text,
        email:
        _emailController.text,
        phone:
        _phoneController.text,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        'Profil enregistré avec succès.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        error.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _showMessage(
    String message, {
      bool isError = false,
    }) {
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? Colors.red : Colors.green,
      ),
    );
    }

    InputDecoration _decoration(
      String label,
      IconData icon,
    ) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mon profil'),
        ),
        body: _loading
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 600,
              ),
              child: Card(
                child: Padding(
                  padding:
                  const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [

                        const Icon(
                          Icons.account_circle,
                          size: 72,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        const Text(
                          'Mes coordonnées',
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 32,
                        ),

                        TextFormField(
                          controller:
                          _firstNameController,
                          textInputAction:
                          TextInputAction.next,
                          decoration:
                          _decoration(
                            'Prénom',
                            Icons.person_outline,
                          ),
                          validator: (value) {
                            if (value == null ||
                              value.trim().isEmpty) {
                              return 'Le prénom est obligatoire.';
                              }

                              return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                          _lastNameController,
                          textInputAction:
                          TextInputAction.next,
                          decoration:
                          _decoration(
                            'Nom',
                            Icons.person,
                          ),
                          validator: (value) {
                            if (value == null ||
                              value.trim().isEmpty) {
                              return 'Le nom est obligatoire.';
                              }

                              return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                          _emailController,
                          keyboardType:
                          TextInputType.emailAddress,
                          textInputAction:
                          TextInputAction.next,
                          decoration:
                          _decoration(
                            'Adresse e-mail',
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            final email =
                            value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'L’adresse e-mail est obligatoire.';
                        }

                        if (!email.contains('@')) {
                          return 'Adresse e-mail invalide.';
                        }

                        return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                          _phoneController,
                          keyboardType:
                          TextInputType.phone,
                          textInputAction:
                          TextInputAction.done,
                          decoration:
                          _decoration(
                            'Téléphone',
                            Icons.phone_outlined,
                          ),
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed:
                            _saving
                            ? null
                            : _save,
                            icon: _saving
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(
                              Icons.save,
                            ),
                            label: Text(
                              _saving
                              ? 'Enregistrement...'
                            : 'Enregistrer les modifications',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
}
