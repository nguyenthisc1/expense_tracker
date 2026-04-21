/// Route path constants for MoneyFlow.
///
/// All route strings are defined here. Reference these constants
/// in [AppPages] and in `context.go()` / `context.push()` calls.
abstract final class AppRoutes {
  // ---------------------------------------------------------------------------
  // Splash
  // ---------------------------------------------------------------------------

  /// Initial branding screen shown once at app launch.
  static const String splash = '/splash';

  // ---------------------------------------------------------------------------
  // Root / Shell
  // ---------------------------------------------------------------------------

  /// Shell / bottom-nav root — redirects to [home].
  static const String root = '/';

  // ---------------------------------------------------------------------------
  // Home
  // ---------------------------------------------------------------------------

  /// Dashboard home tab (first shell tab).
  static const String home = '/home';

  // ---------------------------------------------------------------------------
  // Transactions
  // ---------------------------------------------------------------------------

  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';

  /// Edit transaction by id: `/transactions/edit/:id`
  static const String editTransaction = '/transactions/edit/:id';

  static String editTransactionPath(String id) => '/transactions/edit/$id';

  // ---------------------------------------------------------------------------
  // Reports
  // ---------------------------------------------------------------------------

  static const String reports = '/reports';

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------

  static const String categories = '/categories';
  static const String addCategory = '/categories/add';

  /// Edit category by id: `/categories/edit/:id`
  static const String editCategory = '/categories/edit/:id';

  static String editCategoryPath(String id) => '/categories/edit/$id';

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------

  static const String settings = '/settings';

  // ---------------------------------------------------------------------------
  // Pin
  // ---------------------------------------------------------------------------

  static const String pinLock = '/pin-lock';
  static const String changePin = '/settings/change-pin';
  static const String pin = '/settings/pin';
}
