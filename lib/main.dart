import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/features/auth/bloc/auth_bloc.dart';
import 'presentation/features/auth/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const FamilyCallsApp());
}

class FamilyCallsApp extends StatelessWidget {
  const FamilyCallsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: MaterialApp.router(
        title: 'FamilyCalls',
        theme: AppTheme.darkTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
