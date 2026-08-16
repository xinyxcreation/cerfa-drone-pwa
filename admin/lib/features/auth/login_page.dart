import 'package:flutter/material.dart';

import '../../core/auth/admin_auth_service.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {

  final AdminAuthService auth;

  const LoginPage({
    super.key,
    required this.auth,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();

}

class _LoginPageState
    extends State<LoginPage> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  String? error;

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> login() async {

    setState(() {
      loading = true;
      error = null;
    });

    final result =
        await widget.auth.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (result != null) {

      setState(() {
        error = result;
        loading = false;
      });

      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            DashboardPage(
          auth: widget.auth,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 420,
          ),

          child: Card(
            margin:
                const EdgeInsets.all(24),

            child: Padding(
              padding:
                  const EdgeInsets.all(32),

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [

                  const Icon(
                    Icons.flight,
                    size: 54,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    'CERFA Drone',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  const Text(
                    'Administration',
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  TextField(
                    controller:
                        emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Adresse e-mail',
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextField(
                    controller:
                        passwordController,
                    obscureText: true,
                    onSubmitted:
                        (_) => login(),
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Mot de passe',
                    ),
                  ),

                  if (error != null) ...[

                    const SizedBox(
                      height: 16,
                    ),

                    Text(
                      error!,
                      style:
                          TextStyle(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .error,
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: 24,
                  ),

                  FilledButton(
                    onPressed:
                        loading
                            ? null
                            : login,
                    child:
                        loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Se connecter',
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
