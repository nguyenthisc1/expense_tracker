import 'package:expense_tracker/core/di/injection.dart';
import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/widgets/error_view.dart';
import 'package:expense_tracker/core/widgets/loading_indicator.dart';
import 'package:expense_tracker/presentation/categories/cubit/categories_cubit.dart';
import 'package:expense_tracker/presentation/categories/cubit/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';
import '../widget/category_list_item.dart';

enum CategoryFilterType { all, expense, income }

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  CategoryFilterType _filter = CategoryFilterType.all;

  static const Map<CategoryFilterType, String> _filterLabels = {
    CategoryFilterType.all: 'All',
    CategoryFilterType.expense: 'Expense',
    CategoryFilterType.income: 'Income',
  };

  void _onFilterSelected(CategoryFilterType selectedFilter) {
    setState(() {
      _filter = selectedFilter;
    });
    switch (selectedFilter) {
      case CategoryFilterType.all:
        context.read<CategoriesCubit>().getCategoriesByTypeTransaction(null);
        break;
      case CategoryFilterType.expense:
        context.read<CategoriesCubit>().getCategoriesByTypeTransaction(
          TransactionType.expense,
        );
        break;
      case CategoryFilterType.income:
        context.read<CategoriesCubit>().getCategoriesByTypeTransaction(
          TransactionType.income,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingIndicator(message: 'Loading Infomation...');
        }

        if (state.errorMessage != null) {
          return ErrorView(
            message: state.errorMessage,
            // onRetry: _reloadTransactions,
          );
        }

        return AppScaffold(
          appBar: MoneyFlowAppBar(titleText: 'Categories'),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('${AppRoutes.categories}/add'),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            child: const Icon(LucideIcons.plus),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.sm,
                ),
                child: _FilterToggle(
                  filterLabels: _filterLabels,
                  selected: _filter,
                  onSelected: _onFilterSelected,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: state.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final cat = state.categories[i];
                    return CategoryListItem(data: cat, onTap: () {});
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Toggle
// ---------------------------------------------------------------------------

class _FilterToggle extends StatelessWidget {
  const _FilterToggle({
    required this.filterLabels,
    required this.selected,
    required this.onSelected,
  });

  final Map<CategoryFilterType, String> filterLabels;
  final CategoryFilterType selected;
  final ValueChanged<CategoryFilterType> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = CategoryFilterType.values;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: AppRadius.radiusFull,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selected == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadius.radiusFull,
                ),
                alignment: Alignment.center,
                child: Text(
                  filterLabels[filter]!,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
