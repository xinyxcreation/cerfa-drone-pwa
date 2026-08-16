import 'package:flutter/material.dart';

import 'core/auth/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/dashboard/dashboard_page.dart';

void main() {
  runApp(const CerfaAdminApp());
}

class CerfaAdminApp extends StatefulWidget {
  const CerfaAdminApp({super.key});

  @override
  State<CerfaAdminApp> createState() =>
      _CerfaAdminAppState();
}

class _CerfaAdminAppState
    extends State<CerfaAdminApp> {

  final AdminAuthService auth =
      AdminAuthService();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    await auth.restoreSession();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CERFA Drone Administration',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.theme,
      home: loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : auth.isAuthenticated
              ? DashboardPage(auth: auth)
              : LoginPage(auth: auth),
    );
  }
}
