import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/entity/transaction_type.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, this.transactionId});

  final String? transactionId;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  TransactionType _type = TransactionType.expense;
  String _amount = '42.50';
  int _selectedCategory = 0;
  DateTime _date = DateTime.now();
  final TextEditingController _memoController = TextEditingController();

  static const _categories = [
    _CategoryData('Food', LucideIcons.utensils, AppColors.emerald500),
    _CategoryData('Transport', LucideIcons.car, Color(0xFF3B82F6)),
    _CategoryData('Shopping', LucideIcons.shoppingBag, Color(0xFF8B5CF6)),
    _CategoryData('Other', LucideIcons.layoutGrid, AppColors.slate500),
  ];

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onNumberPad(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
          if (_amount.isEmpty) _amount = '0';
        }
      } else if (value == '.') {
        if (!_amount.contains('.')) {
          _amount = '$_amount.';
        }
      } else {
        if (_amount == '0') {
          _amount = value;
        } else if (_amount.contains('.') &&
            _amount.split('.').last.length >= 2) {
          // max 2 decimal places
        } else {
          _amount = '$_amount$value';
        }
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
    if (picked != null) setState(() => _date = picked);
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
    return Column(
      children: [
        _TypeToggle(
          type: _type,
          onChanged: (t) => setState(() => _type = t),
        ),
        const SizedBox(height: AppSpacing.xl),
        _AmountDisplay(amount: _amount, type: _type),
        const SizedBox(height: AppSpacing.xl),
        _CategoryPicker(
          categories: _categories,
          selected: _selectedCategory,
          onSelected: (i) => setState(() => _selectedCategory = i),
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
        _SaveButton(type: _type),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Type Toggle
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Amount Display
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Category Picker
// ---------------------------------------------------------------------------

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<_CategoryData> categories;
  final int selected;
  final ValueChanged<int> onSelected;

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
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final cat = categories[i];
              final isSelected = selected == i;
              return GestureDetector(
                onTap: () => onSelected(i),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cat.color.withValues(alpha: 0.15)
                        : AppColors.surfaceVariantLight,
                    borderRadius: AppRadius.radiusMd,
                    border: isSelected
                        ? Border.all(color: cat.color, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon, size: 22, color: cat.color),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        cat.name,
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected
                              ? cat.color
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
}

// ---------------------------------------------------------------------------
// Field Row
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Memo Field
// ---------------------------------------------------------------------------

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
            child: Icon(LucideIcons.stickyNote, size: 18, color: AppColors.primary),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Add note...',
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

// ---------------------------------------------------------------------------
// Number Pad
// ---------------------------------------------------------------------------

class _NumberPad extends StatelessWidget {
  const _NumberPad({required this.onTap});

  final ValueChanged<String> onTap;

  static const _keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '.', '0', 'backspace',
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
                ? const Icon(LucideIcons.delete, size: 20, color: AppColors.textSecondaryLight)
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

// ---------------------------------------------------------------------------
// Save Button
// ---------------------------------------------------------------------------

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.type});

  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: AppRadius.radiusFull,
        ),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.arrowRight),
          label: const Text('Save Transaction'),
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

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _CategoryData {
  const _CategoryData(this.name, this.icon, this.color);
  final String name;
  final IconData icon;
  final Color color;
}
