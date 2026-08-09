import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../../../core/config/app_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onLoggedIn,
  });

  final VoidCallback onLoggedIn;

  @override
  State<LoginPage> createState() =>
  _LoginPageState();
}

class _LoginPageState
extends State<LoginPage> {

  final _formKey =
  GlobalKey<FormState>();

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  final _authService =
  const AuthService();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!
      .validate()) {
      return;
      }

      setState(() {
        _loading = true;
      });

    try {
      await _authService.login(
        email: _emailController.text,
        password:
        _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      widget.onLoggedIn();

    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor:
          Colors.red.shade700,
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 440,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [

                  Container(
                    padding:
                    const EdgeInsets.all(24),
                    decoration:
                    BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          AppConfig.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                        24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                          .stretch,
                          children: [

                            const Text(
                              'Bienvenue',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              'Connectez-vous pour continuer.',
                              style: TextStyle(
                                color: Colors
                                .grey
                                .shade600,
                              ),
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            TextFormField(
                              controller:
                              _emailController,
                              keyboardType:
                              TextInputType
                              .emailAddress,
                              autocorrect: false,
                              textInputAction:
                              TextInputAction
                              .next,
                              decoration:
                              const InputDecoration(
                                labelText:
                                'Adresse e-mail',
                                prefixIcon:
                                Icon(
                                  Icons
                                  .email_outlined,
                                ),
                              ),
                              validator:
                              (value) {
                                if (value == null ||
                                  value.trim().isEmpty) {
                                  return 'Saisissez votre adresse e-mail.';
                                  }

                                  if (!value
                                    .contains('@')) {
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
                              _passwordController,
                              obscureText:
                              _obscurePassword,
                              textInputAction:
                              TextInputAction
                              .done,
                              onFieldSubmitted:
                              (_) {
                                if (!_loading) {
                                  _login();
                                }
                              },
                              decoration:
                              InputDecoration(
                                labelText:
                                'Mot de passe',
                                prefixIcon:
                                const Icon(
                                  Icons
                                  .lock_outline,
                                ),
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
                                    ? Icons
                                    .visibility_outlined
                                    : Icons
                                    .visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator:
                              (value) {
                                if (value == null ||
                                  value.isEmpty) {
                                  return 'Saisissez votre mot de passe.';
                                  }

                                  return null;
                              },
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            ElevatedButton(
                              onPressed:
                              _loading
                              ? null
                              : _login,
                              child:
                              _loading
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth:
                                  2,
                                  color:
                                  Colors.white,
                                ),
                              )
                              : const Text(
                                'Se connecter',
                                style:
                                TextStyle(
                                  fontSize:
                                  16,
                                  fontWeight:
                                  FontWeight
                                  .w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
