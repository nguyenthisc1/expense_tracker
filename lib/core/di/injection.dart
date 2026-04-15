import 'package:expense_tracker/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:expense_tracker/presentation/reports/cubit/report_cubit.dart';
import 'package:expense_tracker/features/settings/domain/usecase/update_setting_usecase.dart';
import 'package:expense_tracker/presentation/settings/cubit/setting_cubit.dart';
import 'package:expense_tracker/presentation/transactions/bloc/transaction_bloc.dart';
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
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerPresentation();
}

// ────────────────────────────────────────────────────────────────────────────
// Isar
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

  // ── Settings ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetSettingsUsecase(sl<SettingsRepository>()));
  sl.registerLazySingleton(
    () => UpdateSettingsUsecase(sl<SettingsRepository>()),
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
    () => ReportCubit(getMonthlySummaryUsecase: sl<GetMonthlySummaryUsecase>()),
  );

  sl.registerFactory(
    () => SettingsCubit(
      getSettingsUsecase: sl<GetSettingsUsecase>(),
      updateSettingsUsecase: sl<UpdateSettingsUsecase>(),
    ),
  );
}
