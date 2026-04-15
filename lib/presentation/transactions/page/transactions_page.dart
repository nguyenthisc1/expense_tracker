import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/di/injection.dart';
import '../../../core/entity/transaction_type.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../features/categories/domain/entity/category_entity.dart';
import '../../../features/categories/domain/usecase/get_categories_usecase.dart';
import '../../../features/transactions/domain/entity/transaction_entity.dart';
import '../../../routes/app_routes.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widget/transaction_list_item.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int _selectedFilter = 0;
  List<CategoryEntity> _categories = const [];
  bool _isLoadingCategories = true;
  String? _categoryError;

  static const _filters = ['All', 'Income', 'Expenses', 'Category'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });

    try {
      final categories = await sl<GetCategoriesUsecase>()();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _categoryError = error.toString();
        _isLoadingCategories = false;
      });
    }
  }

  void _reloadTransactions() {
    context.read<TransactionBloc>().add(
      LoadTransactions(type: _selectedTypeFilter),
    );
  }

  TransactionType? get _selectedTypeFilter {
    switch (_selectedFilter) {
      case 1:
        return TransactionType.income;
      case 2:
        return TransactionType.expense;
      default:
        return null;
    }
  }

  Future<void> _openTransactionForm(String route) async {
    final changed = await context.push<bool>(route);
    if (changed == true && mounted) {
      _reloadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MoneyFlowAppBar(
        titleText: 'History',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionForm(AppRoutes.addTransaction),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(LucideIcons.plus),
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          if (_isLoadingCategories && state.transactions.isEmpty) {
            return const LoadingIndicator(message: 'Loading transactions...');
          }

          if (_categoryError != null && state.transactions.isEmpty) {
            return ErrorView(
              message: _categoryError,
              onRetry: _loadCategories,
            );
          }

          if (state.isLoading && state.transactions.isEmpty) {
            return const LoadingIndicator(message: 'Loading transactions...');
          }

          if (state.errorMessage != null && state.transactions.isEmpty) {
            return ErrorView(
              message: state.errorMessage,
              onRetry: _reloadTransactions,
            );
          }

          final groups = _groupTransactions(state.transactions);

          return Column(
            children: [
              _FilterRow(
                filters: _filters,
                selected: _selectedFilter,
                onSelected: (index) {
                  setState(() => _selectedFilter = index);
                  _reloadTransactions();
                },
              ),
              Expanded(
                child: groups.isEmpty
                    ? EmptyState(
                        title: 'No transactions yet',
                        subtitle:
                            'Start by adding your first income or expense entry.',
                        actionLabel: 'Add transaction',
                        onAction: () => _openTransactionForm(
                          AppRoutes.addTransaction,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.base,
                          vertical: AppSpacing.base,
                        ),
                        itemCount: groups.length,
                        itemBuilder: (context, groupIndex) {
                          final group = groups[groupIndex];
                          return _TransactionGroup(
                            group: group,
                            onTapTransaction: (transaction) {
                              _openTransactionForm(
                                AppRoutes.editTransactionPath(transaction.id),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<_DateGroup> _groupTransactions(List<TransactionEntity> transactions) {
    final grouped = <DateTime, List<TransactionEntity>>{};

    for (final transaction in transactions) {
      final key = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      grouped.putIfAbsent(key, () => []).add(transaction);
    }

    final sortedDates = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      final items = grouped[date] ?? const [];
      return _DateGroup(
        date: MoneyFlowDateUtils.formatRelative(date),
        dateLabel: MoneyFlowDateUtils.formatDayMonthYear(date),
        items: items
            .map((transaction) => _TransactionViewData(
                  transaction: transaction,
                  category: _categories.firstWhereOrNull(
                    (category) => category.id == transaction.categoryId,
                  ),
                ))
            .toList(),
      );
    }).toList();
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isSelected = selected == index;
          final isLast = index == filters.length - 1;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: AppRadius.radiusFull,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filters[index],
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (isLast) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 14,
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondaryLight,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({
    required this.group,
    required this.onTapTransaction,
  });

  final _DateGroup group;
  final ValueChanged<TransactionEntity> onTapTransaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.base,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text(group.date, style: AppTypography.headlineSmall),
              const SizedBox(width: AppSpacing.sm),
              Text(group.dateLabel, style: AppTypography.labelSmall),
            ],
          ),
        ),
        ...List.generate(group.items.length, (index) {
          final item = group.items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < group.items.length - 1 ? AppSpacing.sm : 0,
            ),
            child: GestureDetector(
              onTap: () => onTapTransaction(item.transaction),
              child: TransactionListItem(
                title: item.transaction.title,
                subtitle: item.subtitle,
                icon: item.icon,
                iconColor: item.iconColor,
                amount: CurrencyUtils.format(item.transaction.amount),
                isIncome: item.transaction.type == TransactionType.income,
              ),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.base),
      ],
    );
  }
}

class _DateGroup {
  const _DateGroup({
    required this.date,
    required this.dateLabel,
    required this.items,
  });

  final String date;
  final String dateLabel;
  final List<_TransactionViewData> items;
}

class _TransactionViewData {
  const _TransactionViewData({
    required this.transaction,
    required this.category,
  });

  final TransactionEntity transaction;
  final CategoryEntity? category;

  String get subtitle {
    final categoryName = category?.name ?? 'Uncategorized';
    final time = MoneyFlowDateUtils.formatTime(transaction.date);
    return '$categoryName • $time';
  }

  IconData get icon {
    switch (category?.iconName) {
      case 'utensils':
        return LucideIcons.utensils;
      case 'car':
        return LucideIcons.car;
      case 'shoppingBag':
        return LucideIcons.shoppingBag;
      case 'banknote':
        return LucideIcons.banknote;
      case 'briefcase':
        return LucideIcons.briefcase;
      case 'layoutGrid':
        return LucideIcons.layoutGrid;
      default:
        return transaction.type == TransactionType.income
            ? LucideIcons.banknote
            : LucideIcons.receipt;
    }
  }

  Color get iconColor => category != null
      ? Color(category!.colorValue)
      : transaction.type == TransactionType.income
          ? AppColors.income
          : AppColors.expense;
}
