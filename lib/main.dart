import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const FamilyCallsApp());
}

class FamilyCallsApp extends StatelessWidget {
  const FamilyCallsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FamilyCalls',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
