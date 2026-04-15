import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/di/injection.dart';
import '../../../core/entity/transaction_type.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../features/categories/domain/entity/category_entity.dart';
import '../../../features/categories/domain/usecase/get_categories_usecase.dart';
import '../../../features/transactions/domain/entity/transaction_entity.dart';
import '../../../features/transactions/domain/usecase/get_transaction_by_id_usecase.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, this.transactionId});

  final String? transactionId;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _memoController = TextEditingController();
  final Uuid _uuid = const Uuid();

  TransactionType _type = TransactionType.expense;
  String _amount = '0';
  DateTime _date = DateTime.now();
  List<CategoryEntity> _categories = const [];
  String? _selectedCategoryId;
  bool _isBootstrapping = true;
  bool _isSubmitting = false;
  String? _bootstrapError;
  TransactionEntity? _existingTransaction;

  bool get _isEditing => widget.transactionId != null;

  List<CategoryEntity> get _visibleCategories => _categories
      .where((category) => category.type == _type)
      .toList();

  CategoryEntity? get _selectedCategory => _visibleCategories.firstWhereOrNull(
    (category) => category.id == _selectedCategoryId,
  );

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isBootstrapping = true;
      _bootstrapError = null;
    });

    try {
      final categories = await sl<GetCategoriesUsecase>()();
      TransactionEntity? transaction;

      if (_isEditing) {
        transaction = await sl<GetTransactionByIdUsecase>()(widget.transactionId!);
      }

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _existingTransaction = transaction;

        if (transaction != null) {
          _type = transaction.type;
          _amount = _formatEditableAmount(transaction.amount);
          _date = transaction.date;
          _selectedCategoryId = transaction.categoryId;
          _memoController.text = transaction.note ?? transaction.title;
        } else {
          _syncSelectedCategoryForType(_type);
        }

        _isBootstrapping = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _bootstrapError = error.toString();
        _isBootstrapping = false;
      });
    }
  }

  void _syncSelectedCategoryForType(TransactionType type) {
    final available = _categories.where((category) => category.type == type);
    if (available.isEmpty) {
      _selectedCategoryId = null;
      return;
    }

    if (available.any((category) => category.id == _selectedCategoryId)) {
      return;
    }

    _selectedCategoryId = available.first.id;
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _type = type;
      _syncSelectedCategoryForType(type);
    });
  }

  void _onNumberPad(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
          if (_amount.isEmpty) {
            _amount = '0';
          }
        }
        return;
      }

      if (value == '.') {
        if (!_amount.contains('.')) {
          _amount = '$_amount.';
        }
        return;
      }

      if (_amount == '0') {
        _amount = value;
      } else if (_amount.contains('.') && _amount.split('.').last.length >= 2) {
        return;
      } else {
        _amount = '$_amount$value';
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    context.hideKeyboard();

    final amount = _amount.toDoubleOrNull();
    final category = _selectedCategory;

    if (amount == null) {
      context.showSnackBar('Please enter a valid amount.', isError: true);
      return;
    }

    if (category == null) {
      context.showSnackBar(
        'Please select a category before saving.',
        isError: true,
      );
      return;
    }

    final now = DateTime.now();
    final rawMemo = _memoController.text.trim();
    final title = rawMemo.isEmpty ? category.name : rawMemo;

    final transaction = TransactionEntity(
      id: _existingTransaction?.id ?? _uuid.v4(),
      title: title,
      amount: amount,
      type: _type,
      date: _date,
      categoryId: category.id,
      note: rawMemo.isEmpty ? null : rawMemo,
      createdAt: _existingTransaction?.createdAt ?? now,
      updatedAt: now,
    );

    setState(() => _isSubmitting = true);

    if (_isEditing) {
      context.read<TransactionBloc>().add(UpdateTransactionRequested(transaction));
      return;
    }

    context.read<TransactionBloc>().add(AddTransactionRequested(transaction));
  }

  String get _dateLabel {
    final now = DateTime.now();
    if (_date.day == now.day &&
        _date.month == now.month &&
        _date.year == now.year) {
      return 'Today';
    }
    return '${_date.day}/${_date.month}/${_date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isBootstrapping) {
      return const LoadingIndicator(message: 'Loading transaction form...');
    }

    if (_bootstrapError != null) {
      return ErrorView(
        message: _bootstrapError,
        onRetry: _loadInitialData,
      );
    }

    if (_visibleCategories.isEmpty) {
      return const EmptyState(
        title: 'No categories available',
        subtitle: 'Create at least one category before adding transactions.',
      );
    }

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (!_isSubmitting) {
          return;
        }

        if (state.errorMessage != null) {
          setState(() => _isSubmitting = false);
          context.showSnackBar(state.errorMessage!, isError: true);
          return;
        }

        if (!state.isLoading) {
          context.pop(true);
        }
      },
      child: LoadingOverlay(
        isLoading: _isSubmitting,
        message: _isEditing ? 'Updating transaction...' : 'Saving transaction...',
        child: Column(
          children: [
            _TypeToggle(
              type: _type,
              onChanged: _onTypeChanged,
            ),
            const SizedBox(height: AppSpacing.xl),
            _AmountDisplay(amount: _amount, type: _type),
            const SizedBox(height: AppSpacing.xl),
            _CategoryPicker(
              categories: _visibleCategories,
              selectedCategoryId: _selectedCategoryId,
              onSelected: (categoryId) {
                setState(() => _selectedCategoryId = categoryId);
              },
            ),
            const SizedBox(height: AppSpacing.base),
            _FieldRow(
              icon: LucideIcons.calendar,
              label: 'Date',
              value: _dateLabel,
              onTap: _pickDate,
            ),
            const SizedBox(height: AppSpacing.sm),
            _MemoField(controller: _memoController),
            const SizedBox(height: AppSpacing.xl),
            _NumberPad(onTap: _onNumberPad),
            const SizedBox(height: AppSpacing.xl),
            _SaveButton(
              label: _isEditing ? 'Update Transaction' : 'Save Transaction',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  String _formatEditableAmount(double amount) {
    final fixed = amount.toStringAsFixed(2);
    if (fixed.endsWith('.00')) {
      return amount.toStringAsFixed(0);
    }
    return fixed;
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.type, required this.onChanged});

  final TransactionType type;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: AppRadius.radiusFull,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _TypeTab(
            label: 'Expense',
            isSelected: type == TransactionType.expense,
            selectedColor: AppColors.expense,
            onTap: () => onChanged(TransactionType.expense),
          ),
          _TypeTab(
            label: 'Income',
            isSelected: type == TransactionType.income,
            selectedColor: AppColors.income,
            onTap: () => onChanged(TransactionType.income),
          ),
        ],
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: AppRadius.radiusFull,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({required this.amount, required this.type});

  final String amount;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    final color = type == TransactionType.income
        ? AppColors.income
        : AppColors.expense;

    return Column(
      children: [
        Text(
          'Enter Amount',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '\$ $amount',
          style: AppTypography.displayLarge.copyWith(color: color),
        ),
      ],
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category', style: AppTypography.titleMedium),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final category = categories[index];
              final color = Color(category.colorValue);
              final isSelected = selectedCategoryId == category.id;

              return GestureDetector(
                onTap: () => onSelected(category.id),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : AppColors.surfaceVariantLight,
                    borderRadius: AppRadius.radiusMd,
                    border: isSelected
                        ? Border.all(color: color, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_iconForName(category.iconName), size: 22, color: color),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        category.name,
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected
                              ? color
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _iconForName(String iconName) {
    switch (iconName) {
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
        return LucideIcons.receipt;
    }
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariantLight,
          borderRadius: AppRadius.input,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTypography.bodyMedium),
            const Spacer(),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoField extends StatelessWidget {
  const _MemoField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: AppRadius.input,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.base),
            child: Icon(
              LucideIcons.stickyNote,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Add title or note...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad({required this.onTap});

  final ValueChanged<String> onTap;

  static const _keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    'backspace',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: AppSpacing.xs,
      crossAxisSpacing: AppSpacing.xs,
      children: _keys.map((key) {
        return InkWell(
          onTap: () => onTap(key),
          borderRadius: AppRadius.radiusMd,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariantLight,
              borderRadius: AppRadius.radiusMd,
            ),
            alignment: Alignment.center,
            child: key == 'backspace'
                ? const Icon(
                    LucideIcons.delete,
                    size: 20,
                    color: AppColors.textSecondaryLight,
                  )
                : Text(
                    key,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: AppRadius.radiusFull,
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(LucideIcons.arrowRight),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.radiusFull,
            ),
          ),
        ),
      ),
    );
  }
}
