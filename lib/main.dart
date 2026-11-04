import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/di/injection.dart';
import 'app/app_router.dart';
import 'presentation/theme/theme.dart';
import 'l10n/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Invite links are `https://<host>/r/<code>`; the web build reads the path,
  // so the edge must serve index.html for unknown paths.
  usePathUrlStrategy();
  configureDependencies();
  runApp(const RoomTimeApp());
}

class RoomTimeApp extends StatelessWidget {
  const RoomTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FaceTime-style: every screen sits on the camera or black (flows.md §14).
    return MaterialApp.router(
      // Brand name, never translated; the locale follows the system and
      // falls back to English (template) for unsupported languages.
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
