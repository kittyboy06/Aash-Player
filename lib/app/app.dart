import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../../shared/navigation/adaptive_shell.dart';

class AashPlayerApp extends ConsumerStatefulWidget {
  const AashPlayerApp({super.key});

  @override
  ConsumerState<AashPlayerApp> createState() => _AashPlayerAppState();
}

class _AashPlayerAppState extends ConsumerState<AashPlayerApp> {
  late final _router = AppRouter.getRouter((context, navigationShell) {
    return AdaptiveShell(navigationShell: navigationShell);
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aash Player',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Default to dark theme for music players
      theme: AppTheme.getLightTheme(null),
      darkTheme: AppTheme.getDarkTheme(null),
      routerConfig: _router,
    );
  }
}
