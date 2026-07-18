import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Global keys for navigator state management
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final _playlistsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'playlists',
);
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

// Placeholder screen builder to simulate tabs
Widget _buildPlaceholder(String title) {
  return Scaffold(
    body: Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class AppRouter {
  AppRouter._();

  static GoRouter getRouter(
    Widget Function(BuildContext, StatefulNavigationShell) shellBuilder,
  ) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return shellBuilder(context, navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => _buildPlaceholder('Home Screen'),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _libraryNavigatorKey,
              routes: [
                GoRoute(
                  path: '/library',
                  builder: (context, state) =>
                      _buildPlaceholder('Library Screen'),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _playlistsNavigatorKey,
              routes: [
                GoRoute(
                  path: '/playlists',
                  builder: (context, state) =>
                      _buildPlaceholder('Playlists Screen'),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _searchNavigatorKey,
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (context, state) =>
                      _buildPlaceholder('Search Screen'),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _settingsNavigatorKey,
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) =>
                      _buildPlaceholder('Settings Screen'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
