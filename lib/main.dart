import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:roomtime/core/di/injection.dart';
import 'package:roomtime/core/router/app_router.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Use /r/<code> paths instead of hash URLs for deep links.
  usePathUrlStrategy();
  configureDependencies();
  runApp(const RoomTimeApp());
}

class RoomTimeApp extends StatelessWidget {
  const RoomTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
