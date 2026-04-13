import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Static service locator for MoneyFlow dependency injection.
///
/// Holds singleton instances of Isar, repositories, use cases, and blocs.
/// Call [ServiceLocator.init] once in [main] before [runApp].
///
/// Feature implementations register their own dependencies in
/// [_registerFeatures] as they are developed.
final class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  late Isar _isar;

  Isar get isar => _isar;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Initializes all dependencies. Must be awaited before [runApp].
  static Future<void> init() async {
    await _instance._initIsar();
    _instance._registerFeatures();
  }

  Future<void> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      _isarSchemas,
      directory: dir.path,
    );
  }

  // ---------------------------------------------------------------------------
  // Isar schemas
  //
  // Register all Isar-annotated @Collection schemas here.
  // Import the generated .g.dart files for each model as features are built.
  // ---------------------------------------------------------------------------
  static const List<CollectionSchema> _isarSchemas = [
    // TransactionModelSchema,   // add when transactions feature is implemented
    // CategoryModelSchema,      // add when categories feature is implemented
    // SettingsModelSchema,      // add when settings feature is implemented
  ];

  // ---------------------------------------------------------------------------
  // Feature registrations
  //
  // Add datasource, repository, usecase, and bloc registrations here
  // as each feature is implemented. Keep one bloc per feature registration block.
  // ---------------------------------------------------------------------------
  void _registerFeatures() {
    // Transactions feature — uncomment as implemented
    // _registerTransactionsFeature();

    // Categories feature — uncomment as implemented
    // _registerCategoriesFeature();

    // Reports feature — uncomment as implemented
    // _registerReportsFeature();

    // Settings feature — uncomment as implemented
    // _registerSettingsFeature();
  }

  // ---------------------------------------------------------------------------
  // Disposal
  // ---------------------------------------------------------------------------

  /// Closes all resources. Call when the app is being torn down (tests, etc.).
  static Future<void> dispose() async {
    if (_instance._isar.isOpen) {
      await _instance._isar.close();
    }
  }
}
