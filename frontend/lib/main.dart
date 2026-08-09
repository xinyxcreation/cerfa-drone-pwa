import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/services/auth_service.dart';
import 'features/home/presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const CerfaDroneApp(),
  );
}

class CerfaDroneApp extends StatefulWidget {
  const CerfaDroneApp({
    super.key,
  });

  @override
  State<CerfaDroneApp> createState() =>
  _CerfaDroneAppState();
}

class _CerfaDroneAppState
extends State<CerfaDroneApp> {

  bool _loggedIn = false;
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();

    _checkSession();
  }

  Future<void> _checkSession() async {
    final authenticated =
    await const AuthService()
    .hasSession();

    if (!mounted) {
      return;
    }

    setState(() {
      _loggedIn = authenticated;
      _checkingSession = false;
    });
  }

  void _onLoggedIn() {
    setState(() {
      _loggedIn = true;
    });
  }

  void _onLogout() {
    setState(() {
      _loggedIn = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'CERFA DRONE',

      theme:
      AppTheme.light(),

      home: _checkingSession
      ? const _LoadingPage()
      : _loggedIn
      ? HomePage(
        onLogout:
        _onLogout,
      )
      : LoginPage(
        onLoggedIn:
        _onLoggedIn,
      ),
    );
  }
}

class _LoadingPage
extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Scaffold(
      backgroundColor:
      Color(0xFFF5F5F5),
      body: Center(
        child:
        CircularProgressIndicator(
          color: Color(
            0xFFE30613,
          ),
        ),
      ),
    );
  }
}
