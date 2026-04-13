import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

// Feature pages are imported here as each feature is implemented.
// Placeholder widgets are used until then.

/// GoRouter configuration for MoneyFlow.
///
/// Uses a [ShellRoute] with a bottom navigation bar to host the four
/// main tabs: Transactions, Reports, Categories, and Settings.
///
/// As feature pages are implemented, replace [_PlaceholderPage] with
/// the real page imports from each feature's presentation/page/ folder.
final class AppPages {
  AppPages._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.transactions,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          // ------------------------------------------------------------------
          // Transactions tab
          // ------------------------------------------------------------------
          GoRoute(
            path: AppRoutes.transactions,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(title: 'Transactions'),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Add Transaction'),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => _PlaceholderPage(
                  title: 'Edit Transaction (${state.pathParameters['id']})',
                ),
              ),
            ],
          ),

          // ------------------------------------------------------------------
          // Reports tab
          // ------------------------------------------------------------------
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(title: 'Reports'),
            ),
          ),

          // ------------------------------------------------------------------
          // Categories tab
          // ------------------------------------------------------------------
          GoRoute(
            path: AppRoutes.categories,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(title: 'Categories'),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Add Category'),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => _PlaceholderPage(
                  title: 'Edit Category (${state.pathParameters['id']})',
                ),
              ),
            ],
          ),

          // ------------------------------------------------------------------
          // Settings tab
          // ------------------------------------------------------------------
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderPage(title: 'Settings'),
            ),
          ),
        ],
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Shell — bottom navigation bar
// ---------------------------------------------------------------------------

class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndexOf(location),
        onDestinationSelected: (index) => _onTabSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.swap_vert_outlined),
            selectedIcon: Icon(Icons.swap_vert),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _tabIndexOf(String location) {
    if (location.startsWith(AppRoutes.reports)) return 1;
    if (location.startsWith(AppRoutes.categories)) return 2;
    if (location.startsWith(AppRoutes.settings)) return 3;
    return 0;
  }

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.transactions);
      case 1:
        context.go(AppRoutes.reports);
      case 2:
        context.go(AppRoutes.categories);
      case 3:
        context.go(AppRoutes.settings);
    }
  }
}

// ---------------------------------------------------------------------------
// Placeholder page — replaced as features are implemented
// ---------------------------------------------------------------------------

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(under construction)',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
