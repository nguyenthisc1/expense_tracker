import 'package:expense_tracker/core/seed/app_seed_service.dart';
import 'package:expense_tracker/features/app_lock/data/datasource/app_lock_local_datasource.dart';
import 'package:expense_tracker/features/app_lock/data/datasource/app_lock_local_datasource_impl.dart';
import 'package:expense_tracker/features/app_lock/data/repository/app_lock_repository_impl.dart';
import 'package:expense_tracker/features/app_lock/domain/repository/app_lock_repository.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/change_pin_lock_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/disable_pin_lock_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/enable_pin_lock_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/get_app_lock_setting_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/verify_pin_lock_usecase.dart';
import 'package:expense_tracker/features/categories/domain/usecase/get_all_categories_usecase.dart';
import 'package:expense_tracker/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:expense_tracker/features/export/data/datasource/export_local_datasource.dart';
import 'package:expense_tracker/features/export/data/datasource/export_local_datasource_impl.dart';
import 'package:expense_tracker/features/export/data/repository/export_repository_impl.dart';
import 'package:expense_tracker/features/export/domain/repository/export_repository.dart';
import 'package:expense_tracker/features/export/domain/usecase/export_report_pdf_usecase.dart';
import 'package:expense_tracker/features/export/domain/usecase/export_transaction_csv_usecase.dart';
import 'package:expense_tracker/features/reports/domain/usecase/get_detailed_report_usecase.dart';
import 'package:expense_tracker/features/settings/domain/usecase/update_setting_usecase.dart';
import 'package:expense_tracker/presentation/categories/cubit/categories_cubit.dart';
import 'package:expense_tracker/presentation/home/cubit/home_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/pin_entry_cubit.dart';
import 'package:expense_tracker/presentation/reports/cubit/report_cubit.dart';
import 'package:expense_tracker/presentation/settings/cubit/setting_cubit.dart';
import 'package:expense_tracker/presentation/transactions/bloc/transaction_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/categories/data/datasource/category_local_datasource.dart';
import '../../features/categories/data/datasource/category_local_datasource_impl.dart';
import '../../features/categories/data/model/category_model.dart';
import '../../features/categories/data/repository/category_repository_impl.dart';
import '../../features/categories/domain/repository/category_repository.dart';
import '../../features/categories/domain/usecase/add_category_usecase.dart';
import '../../features/categories/domain/usecase/delete_category_usecase.dart';
import '../../features/categories/domain/usecase/get_categorie_by_id_usecase.dart';
import '../../features/categories/domain/usecase/get_categories_usecase.dart';
import '../../features/reports/data/repository/report_repository_impl.dart';
import '../../features/reports/domain/repository/report_repository.dart';
import '../../features/reports/domain/usecase/get_monthly_summary_usecase.dart';
import '../../features/settings/data/datasource/setting_local_datasource.dart';
import '../../features/settings/data/datasource/setting_local_datasource_impl.dart';
import '../../features/settings/data/model/setting_model.dart';
import '../../features/settings/data/repository/setting_repository_impl.dart';
import '../../features/settings/domain/repository/setting_repository.dart';
import '../../features/settings/domain/usecase/get_setting_usecase.dart';
import '../../features/transactions/data/datasource/transaction_local_datasource.dart';
import '../../features/transactions/data/datasource/transaction_local_datasource_impl.dart';
import '../../features/transactions/data/model/transaction_model.dart';
import '../../features/transactions/data/repository/transaction_repository_impl.dart';
import '../../features/transactions/domain/repository/transaction_repository.dart';
import '../../features/transactions/domain/usecase/add_transaction_usecase.dart';
import '../../features/transactions/domain/usecase/delete_transaction_usecase.dart';
import '../../features/transactions/domain/usecase/get_transaction_by_id_usecase.dart';
import '../../features/transactions/domain/usecase/get_transactions_usecase.dart';
import '../../features/transactions/domain/usecase/update_transaction_usecase.dart';

/// Global GetIt service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all application dependencies into [sl].
///
/// Call once in [main] before [runApp]:
/// ```dart
/// await configureDependencies();
/// runApp(const MoneyFlowApp());
/// ```
///
/// Registration strategy:
/// - **Isar** — singleton (one DB for the app lifetime)
/// - **DataSources** — lazy singletons (created on first access, reused)
/// - **Repositories** — lazy singletons (stateless wrappers over datasources)
/// - **UseCases** — lazy singletons (pure functions, no mutable state)
/// - **Blocs/Cubits** — registered as factories in each feature's own
///   BlocProvider so each page gets a fresh instance
Future<void> configureDependencies() async {
  await _registerIsar();
  _registerSecureStorage();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerPresentation();
  _registerSeeds();
}

// ────────────────────────────────────────────────────────────────────────────
// local storage
// ────────────────────────────────────────────────────────────────────────────

Future<void> _registerIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    CategoryModelSchema,
    TransactionModelSchema,
    AppSettingsModelSchema,
  ], directory: dir.path);
  sl.registerSingleton<Isar>(isar);
}

void _registerSecureStorage() {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(),
    ),
  );
}

// ────────────────────────────────────────────────────────────────────────────
// DataSources
// ────────────────────────────────────────────────────────────────────────────

void _registerDataSources() {
  sl.registerLazySingleton<CategoryLocalDatasource>(
    () => CategoryLocalDatasourceImpl(sl<Isar>()),
  );

  sl.registerLazySingleton<TransactionLocalDatasource>(
    () => TransactionLocalDataSourceImpl(sl<Isar>()),
  );

  sl.registerLazySingleton<SettingsLocalDatasource>(
    () => SettingsLocalDatasourceImpl(sl<Isar>()),
  );

  sl.registerLazySingleton<AppLockLocalDatasource>(
    () => AppLockLocalDatasourceImpl(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<ExportLocalDatasource>(
    () => ExportLocalDatasourceImpl(),
  );
}

// ────────────────────────────────────────────────────────────────────────────
// Repositories
// ────────────────────────────────────────────────────────────────────────────

void _registerRepositories() {
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryLocalDatasource>()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl<TransactionLocalDatasource>()),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingRepositoryImpl(sl<SettingsLocalDatasource>()),
  );

  // ReportRepositoryImpl reads from both category and transaction datasources
  // directly to compute aggregated summaries.
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      sl<CategoryLocalDatasource>(),
      sl<TransactionLocalDatasource>(),
    ),
  );

  sl.registerLazySingleton<AppLockRepository>(
    () => AppLockRepositoryImpl(sl<AppLockLocalDatasource>()),
  );

  sl.registerLazySingleton<ExportRepository>(
    () => ExportRepositoryImpl(sl<ExportLocalDatasource>()),
  );
}

// ────────────────────────────────────────────────────────────────────────────
// Use Cases
// ────────────────────────────────────────────────────────────────────────────

void _registerUseCases() {
  // ── Categories ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetCategoriesUsecase(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAllCategoriesUsecase(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCategoryByIdUsecase(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton(() => AddCategoryUsecase(sl<CategoryRepository>()));
  sl.registerLazySingleton(
    () => DeleteCategoryUsecase(sl<CategoryRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateCategoryUsecase(sl<CategoryRepository>()),
  );

  // ── Transactions ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetTransactionsUsecase(sl<TransactionRepository>()),
  );
  sl.registerLazySingleton(
    () => GetTransactionByIdUsecase(sl<TransactionRepository>()),
  );
  sl.registerLazySingleton(
    // AddTransaction validates that the category exists and types match.
    () => AddTransactionUsecase(
      sl<TransactionRepository>(),
      sl<CategoryRepository>(),
    ),
  );
  sl.registerLazySingleton(
    // UpdateTransaction validates existence + category type consistency.
    () => UpdateTransactionUsecase(
      sl<TransactionRepository>(),
      sl<CategoryRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteTransactionUsecase(sl<TransactionRepository>()),
  );

  // ── Reports ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetMonthlySummaryUsecase(sl<ReportRepository>()),
  );
  sl.registerLazySingleton(
    () => GetDetailedReportUsecase(sl<ReportRepository>()),
  );

  // ── Settings ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetSettingsUsecase(sl<SettingsRepository>()));
  sl.registerLazySingleton(
    () => UpdateSettingsUsecase(sl<SettingsRepository>()),
  );

  // ── App lock ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => ChangePinLockUsecase(sl<AppLockRepository>()));
  sl.registerLazySingleton(
    () => GetAppLockSettingsUsecase(sl<AppLockRepository>()),
  );
  sl.registerLazySingleton(() => EnablePinLockUsecase(sl<AppLockRepository>()));
  sl.registerLazySingleton(
    () => DisablePinLockUsecase(sl<AppLockRepository>()),
  );
  sl.registerLazySingleton(() => VerifyPinLockUsecase(sl<AppLockRepository>()));

  // ── Export ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => ExportTransactionCsvUseCase(sl<ExportRepository>()),
  );
  sl.registerLazySingleton(
    () => ExportReportPdfUsecase(sl<ExportRepository>()),
  );
}

// ────────────────────────────────────────────────────────────────────────────
// Blocs
// ────────────────────────────────────────────────────────────────────────────

void _registerPresentation() {
  sl.registerFactory(
    () => TransactionBloc(
      getTransactionsUsecase: sl<GetTransactionsUsecase>(),
      addTransactionUsecase: sl<AddTransactionUsecase>(),
      updateTransactionUsecase: sl<UpdateTransactionUsecase>(),
      deleteTransactionUsecase: sl<DeleteTransactionUsecase>(),
    ),
  );

  sl.registerFactory(
    () => ReportCubit(
      getMonthlySummaryUsecase: sl<GetMonthlySummaryUsecase>(),
      getDetailedReportUsecase: sl<GetDetailedReportUsecase>(),
    ),
  );

  sl.registerFactory(
    () => SettingsCubit(
      getSettingsUsecase: sl<GetSettingsUsecase>(),
      updateSettingsUsecase: sl<UpdateSettingsUsecase>(),
    ),
  );

  sl.registerFactory(
    () => CategoriesCubit(
      getAllCategoriesUsecase: sl<GetAllCategoriesUsecase>(),
      getCategoryByIdUsecase: sl<GetCategoryByIdUsecase>(),
    ),
  );

  sl.registerFactory(
    () => HomeCubit(
      getDetailedReportUsecase: sl<GetDetailedReportUsecase>(),
      getTransactionsUsecase: sl<GetTransactionsUsecase>(),
    ),
  );

  sl.registerFactory(
    () => AppPinLockSettingCubit(
      enablePinLockUsecase: sl<EnablePinLockUsecase>(),
      disablePinLockUsecase: sl<DisablePinLockUsecase>(),
      getAppLockSettingsUsecase: sl<GetAppLockSettingsUsecase>(),
      changePinLockUsecase: sl<ChangePinLockUsecase>(),
      verifyPinLockUsecase: sl<VerifyPinLockUsecase>(),
    ),
  );

  sl.registerFactory(
    () => AppLockCubit(
      getAppLockSettingsUsecase: sl<GetAppLockSettingsUsecase>(),
      verifyPinLockUsecase: sl<VerifyPinLockUsecase>(),
    ),
  );

  sl.registerFactory(() => PinEntryCubit());
}

// ────────────────────────────────────────────────────────────────────────────
// Seeds
// ────────────────────────────────────────────────────────────────────────────
void _registerSeeds() {
  sl.registerLazySingleton<AppSeedService>(
    () => AppSeedService(
      sl<SettingsRepository>(),
      sl<CategoryRepository>(),
      sl<TransactionRepository>(),
    ),
  );
}
