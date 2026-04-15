import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/page/home_page.dart';
import '../features/reports/presentation/page/reports_page.dart';
import '../features/settings/presentation/page/settings_page.dart';
import '../features/splash/presentation/page/splash_page.dart';
import '../features/transactions/presentation/page/add_transaction_page.dart';
import '../features/transactions/presentation/page/transactions_page.dart';
import 'app_routes.dart';

/// GoRouter configuration for MoneyFlow.
///
/// Flow: SplashPage → auto-navigate to ShellRoute (home tab).
/// Shell tabs: Home · Transactions · Reports · Categories · Settings.
final class AppPages {
  AppPages._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (state.matchedLocation == AppRoutes.root) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      // --------------------------------------------------------------------
      // Splash — outside the shell (no bottom nav)
      // --------------------------------------------------------------------
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashPage(),
        ),
      ),

      // --------------------------------------------------------------------
      // Main shell with bottom navigation bar
      // --------------------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          // ----------------------------------------------------------------
          // Home tab
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),

          // ----------------------------------------------------------------
          // Transactions tab
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.transactions,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TransactionsPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddTransactionPage(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => AddTransactionPage(
                  transactionId: state.pathParameters['id'],
                ),
              ),
            ],
          ),

          // ----------------------------------------------------------------
          // Reports tab
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReportsPage(),
            ),
          ),

          // ----------------------------------------------------------------
          // Categories tab (placeholder — implemented separately)
          // ----------------------------------------------------------------
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

          // ----------------------------------------------------------------
          // Settings tab
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
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
    if (location.startsWith(AppRoutes.transactions)) return 1;
    if (location.startsWith(AppRoutes.reports)) return 2;
    if (location.startsWith(AppRoutes.categories)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0; // home
  }

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.transactions);
      case 2:
        context.go(AppRoutes.reports);
      case 3:
        context.go(AppRoutes.categories);
      case 4:
        context.go(AppRoutes.settings);
    }
  }
}

// ---------------------------------------------------------------------------
// Placeholder page — used for unimplemented tabs
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
