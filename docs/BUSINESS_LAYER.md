# MoneyFlow — Business Layer Documentation

> **Scope**: Domain entities, business rules, use cases, repositories, data
> sources, and dependency injection for all four features.
>
> **Architecture**: Feature-based Layered (Clean Architecture lite)  
> `Page → Bloc/Cubit → UseCase → Repository (abstract) → RepositoryImpl → DataSource → Isar`

---

## Table of Contents

1. [Shared Core](#1-shared-core)
2. [Feature: Transactions](#2-feature-transactions)
3. [Feature: Categories](#3-feature-categories)
4. [Feature: Reports](#4-feature-reports)
5. [Feature: Settings](#5-feature-settings)
6. [Dependency Injection (GetIt)](#6-dependency-injection-getit)
7. [Data Flow Diagram](#7-data-flow-diagram)
8. [Error Handling](#8-error-handling)

---

## 1. Shared Core

### 1.1 TransactionType

```
lib/core/entity/transaction_type.dart
```

```dart
enum TransactionType { income, expense }
```

Shared by both **Transactions** and **Categories** features. Categories carry a type to constrain which transactions can reference them.

### 1.2 AppException hierarchy

```
lib/core/errors/app_exeption.dart
```

| Class | Usage |
|-------|-------|
| `AppException` | Base sealed class — carries a human-readable `message`. |
| `ValidationException` | Input does not satisfy field-level constraints (empty name, non-positive amount, bad date range). |
| `NotFoundException` | Entity does not exist in the local Isar database. |
| `BusinessRuleException` | Data is well-formed but violates a domain policy (e.g., deleting a category in use). |

All use cases throw one of these subtypes; presentation blocs catch them and emit a failure state.

---

## 2. Feature: Transactions

### 2.1 Entity

**`TransactionEntity`** (`domain/entity/transaction_entity.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | UUID v4, unique. |
| `title` | `String` | Short description (e.g., "Lunch"). |
| `amount` | `double` | Positive value; currency unit inferred from Settings. |
| `type` | `TransactionType` | `income` or `expense`. |
| `date` | `DateTime` | When the money moved. |
| `categoryId` | `String` | FK → `CategoryEntity.id`. |
| `note` | `String?` | Optional long-form note. |
| `createdAt` | `DateTime` | Record creation timestamp. |
| `updatedAt` | `DateTime` | Last modification timestamp. |

### 2.2 Repository Contract

**`TransactionRepository`** (`domain/repository/transaction_repository.dart`)

```
getTransactions({from, to, type, categoryId}) → List<TransactionEntity>
getTransactionById(id)                         → TransactionEntity?
addTransaction(entity)                         → TransactionEntity
updateTransaction(entity)                      → TransactionEntity
deleteTransaction(id)                          → void
```

### 2.3 Use Cases & Business Rules

#### `GetTransactionsUsecase`
- **Rule**: If both `from` and `to` are provided, `from` must not be after `to` → throws `ValidationException`.
- **Delegates** to `TransactionRepository.getTransactions`.

#### `GetTransactionByIdUsecase`
- **Rule**: If no record is found, throws `NotFoundException`.

#### `AddTransactionUsecase`
- **Rule 1 — title**: Must not be blank → `ValidationException`.
- **Rule 2 — amount**: Must be > 0 → `ValidationException`.
- **Rule 3 — category exists**: The `categoryId` must resolve to an existing `CategoryEntity` → `NotFoundException`.
- **Rule 4 — type match**: `transaction.type` must equal `category.type` → `BusinessRuleException`. (You cannot attach an income transaction to an expense category.)

#### `UpdateTransactionUsecase`
- **Rule 1 — record exists**: Checks `getTransactionById(id)` first → `NotFoundException`.
- **Rule 2–4**: Same validation as `AddTransactionUsecase` (title, amount, category type match).

#### `DeleteTransactionUsecase`
- **Rule**: Confirms the transaction exists before deletion → `NotFoundException`.

### 2.4 Data Layer

| Class | Responsibility |
|-------|----------------|
| `TransactionModel` | Isar `@collection` schema. Indexes: `id` (unique), `date`, `categoryId`, `type`. |
| `TransactionLocalDatasource` (abstract) | Interface for all Isar read/write operations. |
| `TransactionLocalDataSourceImpl` | Concrete implementation. Results sorted by `date` descending; post-query Dart filtering for optional `from/to/type/categoryId`. |
| `TransactionMapper` | Converts `TransactionModel ↔ TransactionEntity`. Handles `type` string ↔ enum conversion; defaults unknown strings to `expense`. |
| `TransactionRepositoryImpl` | Bridges `TransactionLocalDatasource` and the domain via mapper. |

---

## 3. Feature: Categories

### 3.1 Entity

**`CategoryEntity`** (`domain/entity/category_entity.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | UUID v4, unique. |
| `name` | `String` | Display label (e.g., "Food", "Salary"). |
| `type` | `TransactionType` | Determines which transaction types can reference this category. |
| `colorValue` | `int` | `Color.value` integer for UI rendering. |
| `iconName` | `String` | Icon identifier used by the design system. |
| `isDefault` | `bool` | Pre-seeded system categories cannot be deleted. |

### 3.2 Repository Contract

**`CategoryRepository`** (`domain/repository/category_repository.dart`)

```
getCategories({type})                              → List<CategoryEntity>
getCategoryById(id)                                → CategoryEntity?
addCategory(entity)                                → CategoryEntity
updateCategory(entity)                             → CategoryEntity
deleteCategory(id)                                 → void
isCategoryInUse(categoryId)                        → bool
existsCategoryName({name, type, excludeId})        → bool
```

### 3.3 Use Cases & Business Rules

#### `GetCategoriesUsecase`
- Optional `type` filter; returns all categories when omitted.

#### `GetCategoryByIdUsecase`
- **Rule**: Not found → `NotFoundException`.

#### `AddCategoryUsecase`
- **Rule 1 — name**: Must not be blank → `ValidationException`.
- **Rule 2 — duplicate**: A category with the same `name` and `type` must not already exist → `BusinessRuleException`.

#### `DeleteCategoryUsecase`
- **Rule 1 — exists**: Must exist → `NotFoundException`.
- **Rule 2 — in use**: If any transaction references this `categoryId`, deletion is blocked → `BusinessRuleException` ("Cannot delete category because it is being used by transactions.").

### 3.4 Data Layer

| Class | Responsibility |
|-------|----------------|
| `CategoryModel` | Isar `@collection`. Indexes: `id` (unique), `type`. |
| `CategoryLocalDatasource` (abstract) | Interface; includes `existsCategoryName` and `isCategoryInUse`. |
| `CategoryLocalDatasourceImpl` | Name uniqueness check is case-insensitive and trimmed. `isCategoryInUse` queries `TransactionModel` collection by `categoryId`. |
| `CategoryMapper` | `CategoryModel ↔ CategoryEntity`. String ↔ `TransactionType` enum with `expense` as default fallback. |
| `CategoryRepositoryImpl` | Adapts domain calls to datasource; translates `TransactionType` enum to its `.name` string. |

---

## 4. Feature: Reports

### 4.1 Entities

**`MonthlyReportEntity`** (`domain/entity/monthly_report_entity.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `year` | `int` | Calendar year. |
| `month` | `int` | Calendar month (1–12). |
| `totalIncome` | `double` | Sum of all income transactions in the period. |
| `totalExpense` | `double` | Sum of all expense transactions in the period. |
| `balance` | `double` | `totalIncome - totalExpense`. |
| `expenseByCategory` | `List<CategoryExpenseSummaryEntity>` | Per-category breakdown, sorted by `totalAmount` descending. |

**`CategoryExpenseSummaryEntity`** (`domain/entity/category_expense_summary_entity.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `categoryId` | `String` | References `CategoryEntity.id`. |
| `categoryName` | `String` | Denormalized for display without extra lookup. |
| `totalAmount` | `double` | Total expense amount for this category in the period. |
| `colorValue` | `int` | Category color, denormalized for chart rendering. |

### 4.2 Repository Contract

**`ReportRepository`** (`domain/repository/report_repository.dart`)

```
getMonthlySummary({year, month}) → MonthlyReportEntity
```

### 4.3 Use Cases & Business Rules

#### `GetMonthlySummaryUsecase`
- **Rule 1 — month range**: `month` must be between 1 and 12 → `ValidationException`.
- **Rule 2 — year**: Must be > 0 → `ValidationException`.
- Computes the closed date interval `[first day of month, last second of month]` before querying.

### 4.4 Data Layer

The `ReportRepository` has **no dedicated Isar schema**. It is a read-only **aggregation** built from two existing datasources:

| Dependency | Purpose |
|------------|---------|
| `TransactionLocalDatasource` | Fetches transactions within the date range. |
| `CategoryLocalDatasource` | Looks up category metadata for breakdown summaries. |

`ReportRepositoryImpl` performs in-memory aggregation:
1. Filters transactions for the month window.
2. Folds income/expense totals.
3. Groups expenses by `categoryId`, merges with category data, sorts descending.

---

## 5. Feature: Settings

### 5.1 Entity

**`AppSettingsEntity`** (`domain/entity/setting_entity.dart`)

| Field | Type | Default |
|-------|------|---------|
| `currencyCode` | `String` | `"VND"` |
| `locale` | `String` | `"vi_VN"` |
| `isDarkMode` | `bool` | `false` |
| `firstDayOfWeek` | `int` | `1` (Monday) |

### 5.2 Repository Contract

**`SettingsRepository`** (`domain/repository/setting_repository.dart`)

```
getSettings()                        → AppSettingsEntity
updateSettings(entity)               → AppSettingsEntity
```

### 5.3 Use Cases & Business Rules

#### `GetSettingsUsecase`
- No validation — pure delegation to repository.

The `SettingRepositoryImpl` has one embedded business rule:
- **Auto-initialise defaults**: If no settings record exists in Isar on first run, the repository creates and persists a record with the defaults listed above before returning.

### 5.4 Data Layer

| Class | Responsibility |
|-------|----------------|
| `AppSettingsModel` | Isar `@collection`. Single-row pattern: `key` field is always `"app_settings"`, indexed as unique. |
| `SettingsLocalDatasource` (abstract) | `getSettings()` / `updateSettings()` interface. |
| `SettingsLocalDatasourceImpl` | Filters by constant key `"app_settings"` on reads; writes always set the same key. |
| `AppSettingsMapper` | `AppSettingsModel ↔ AppSettingsEntity`. |
| `SettingRepositoryImpl` | Handles the "first-run defaults" creation logic. |

---

## 6. Dependency Injection (GetIt)

### 6.1 Entry Point

```
lib/core/di/injection.dart
```

```dart
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async { ... }
```

Called once in `main()` before `runApp()`:

```dart
await configureDependencies();
runApp(const MoneyFlowApp());
```

### 6.2 Registration Map

```
configureDependencies()
│
├── _registerIsar()
│     └── Isar ──────────────────────── singleton
│           schemas: CategoryModelSchema
│                    TransactionModelSchema
│                    AppSettingsModelSchema
│
├── _registerDataSources()
│     ├── CategoryLocalDatasource ──── lazy singleton
│     │     impl: CategoryLocalDatasourceImpl(Isar)
│     ├── TransactionLocalDatasource ─ lazy singleton
│     │     impl: TransactionLocalDataSourceImpl(Isar)
│     └── SettingsLocalDatasource ──── lazy singleton
│           impl: SettingsLocalDatasourceImpl(Isar)
│
├── _registerRepositories()
│     ├── CategoryRepository ───────── lazy singleton
│     │     impl: CategoryRepositoryImpl(CategoryLocalDatasource)
│     ├── TransactionRepository ─────── lazy singleton
│     │     impl: TransactionRepositoryImpl(TransactionLocalDatasource)
│     ├── SettingsRepository ────────── lazy singleton
│     │     impl: SettingRepositoryImpl(SettingsLocalDatasource)
│     └── ReportRepository ─────────── lazy singleton
│           impl: ReportRepositoryImpl(CategoryLocalDatasource,
│                                      TransactionLocalDatasource)
│
└── _registerUseCases()
      ├── GetCategoriesUsecase(CategoryRepository)
      ├── GetCategoryByIdUsecase(CategoryRepository)
      ├── AddCategoryUsecase(CategoryRepository)
      ├── DeleteCategoryUsecase(CategoryRepository)
      ├── GetTransactionsUsecase(TransactionRepository)
      ├── GetTransactionByIdUsecase(TransactionRepository)
      ├── AddTransactionUsecase(TransactionRepository, CategoryRepository)
      ├── UpdateTransactionUsecase(TransactionRepository, CategoryRepository)
      ├── DeleteTransactionUsecase(TransactionRepository)
      ├── GetMonthlySummaryUsecase(ReportRepository)
      └── GetSettingsUsecase(SettingsRepository)
```

### 6.3 Resolving Dependencies in Blocs

Blocs and Cubits are **not** registered globally. Each feature's `BlocProvider` creates a fresh instance using `sl<UseCase>()`:

```dart
// Example — TransactionsPage
BlocProvider(
  create: (_) => TransactionBloc(
    getTransactions: sl<GetTransactionsUsecase>(),
    addTransaction:  sl<AddTransactionUsecase>(),
    updateTransaction: sl<UpdateTransactionUsecase>(),
    deleteTransaction: sl<DeleteTransactionUsecase>(),
  ),
  child: const TransactionsView(),
)
```

This pattern gives each page its own bloc instance with a clean initial state.

---

## 7. Data Flow Diagram

```
UI (Page / Widget)
      │  dispatches event
      ▼
  Bloc / Cubit
      │  calls use case
      ▼
  UseCase             ← validates inputs, enforces business rules
      │  calls repository method
      ▼
  Repository (abstract interface)
      │  implemented by
      ▼
  RepositoryImpl      ← maps entity ↔ model, delegates to datasource
      │
      ▼
  DataSourceImpl      ← Isar read/write; single source of truth
      │
      ▼
  Isar (on-device NoSQL)
```

Cross-feature dependency (Report aggregation):

```
ReportRepositoryImpl
    ├── TransactionLocalDatasource  (reads transactions for period)
    └── CategoryLocalDatasource     (reads category metadata)
```

---

## 8. Error Handling

| Layer | Responsibility |
|-------|---------------|
| **UseCase** | Validates inputs; throws typed `AppException` subclasses. |
| **RepositoryImpl** | Does not throw business errors — propagates datasource/Isar exceptions as-is. |
| **DataSourceImpl** | Returns `null` (via `findFirst()`) when a record is not found; lets the use case own the "not found" rule. |
| **Bloc** | Wraps `useCase.call()` in `try/catch`; catches `AppException` → emits `*Failure` state with `exception.message`; catches generic `Exception` → emits generic error message. |
| **UI** | Reads `*Failure` state → renders `ErrorView` widget with retry callback. |

### Exception Reference

| Exception | Thrown by |
|-----------|-----------|
| `ValidationException("Category name cannot be empty.")` | `AddCategoryUsecase` |
| `BusinessRuleException("A category with the same name already exists...")` | `AddCategoryUsecase` |
| `NotFoundException("Category was not found.")` | `GetCategoryByIdUsecase`, `DeleteCategoryUsecase` |
| `BusinessRuleException("Cannot delete category because it is being used by transactions.")` | `DeleteCategoryUsecase` |
| `ValidationException("Transaction title cannot be empty.")` | `AddTransactionUsecase`, `UpdateTransactionUsecase` |
| `ValidationException("Transaction amount must be greater than 0.")` | `AddTransactionUsecase`, `UpdateTransactionUsecase` |
| `NotFoundException("Selected category was not found.")` | `AddTransactionUsecase`, `UpdateTransactionUsecase` |
| `BusinessRuleException("Transaction type must match category type.")` | `AddTransactionUsecase`, `UpdateTransactionUsecase` |
| `NotFoundException("Transaction was not found.")` | `GetTransactionByIdUsecase`, `DeleteTransactionUsecase`, `UpdateTransactionUsecase` |
| `ValidationException("Month must be between 1 and 12.")` | `GetMonthlySummaryUsecase` |
| `ValidationException("Year must be greater than 0.")` | `GetMonthlySummaryUsecase` |
| `ValidationException("The start date must be earlier than or equal to the end date.")` | `GetTransactionsUsecase` |
