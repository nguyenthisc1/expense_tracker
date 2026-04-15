import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/di/injection.dart';
import '../presentation/categories/page/categories_page.dart';
import '../presentation/categories/widget/category_form.dart';
import '../presentation/home/page/home_page.dart';
import '../presentation/reports/page/reports_page.dart';
import '../presentation/settings/page/settings_page.dart';
import '../presentation/splash/page/splash_page.dart';
import '../presentation/transactions/bloc/transaction_bloc.dart';
import '../presentation/transactions/bloc/transaction_event.dart';
import '../presentation/transactions/page/add_transaction_page.dart';
import '../presentation/transactions/page/transactions_page.dart';
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
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => sl<TransactionBloc>()..add(const LoadTransactions()),
                child: const TransactionsPage(),
              ),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<TransactionBloc>(),
                  child: const AddTransactionPage(),
                ),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<TransactionBloc>(),
                  child: AddTransactionPage(
                    transactionId: state.pathParameters['id'],
                  ),
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
          // Categories tab
          // ----------------------------------------------------------------
          GoRoute(
            path: AppRoutes.categories,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CategoriesPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const CategoryFormPage(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => CategoryFormPage(
                  categoryId: state.pathParameters['id'],
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
            icon: Icon(LucideIcons.house),
            selectedIcon: Icon(LucideIcons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.arrowUpDown),
            selectedIcon: Icon(LucideIcons.arrowUpDown),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.chartBar),
            selectedIcon: Icon(LucideIcons.chartBar),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.layoutGrid),
            selectedIcon: Icon(LucideIcons.layoutGrid),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.settings),
            selectedIcon: Icon(LucideIcons.settings),
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
