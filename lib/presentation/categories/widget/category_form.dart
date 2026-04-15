import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/entity/transaction_type.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  TransactionType _type = TransactionType.expense;
  int _selectedColorIndex = 0;
  int _selectedIconIndex = 0;
  final _nameController = TextEditingController();

  static const _colors = [
    AppColors.emerald500,
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFFEF4444),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
    Color(0xFF6366F1),
    Color(0xFF84CC16),
  ];

  static const _icons = [
    LucideIcons.utensils,
    LucideIcons.car,
    LucideIcons.shoppingBag,
    LucideIcons.house,
    LucideIcons.film,
    LucideIcons.zap,
    LucideIcons.banknote,
    LucideIcons.briefcase,
    LucideIcons.heart,
    LucideIcons.coffee,
    LucideIcons.gift,
    LucideIcons.dumbbell,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.categoryId != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEditing ? 'Edit Category' : 'New Category',
          style: AppTypography.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryPreview(
              icon: _icons[_selectedIconIndex],
              color: _colors[_selectedColorIndex],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Name', style: AppTypography.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Category name',
                filled: true,
                fillColor: AppColors.surfaceVariantLight,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.input,
                  borderSide: BorderSide.none,
                ),
              ),
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Type', style: AppTypography.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            _TypeToggle(
              type: _type,
              onChanged: (t) => setState(() => _type = t),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Color', style: AppTypography.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            _ColorPicker(
              colors: _colors,
              selected: _selectedColorIndex,
              onSelected: (i) => setState(() => _selectedColorIndex = i),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Icon', style: AppTypography.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            _IconPicker(
              icons: _icons,
              color: _colors[_selectedColorIndex],
              selected: _selectedIconIndex,
              onSelected: (i) => setState(() => _selectedIconIndex = i),
            ),
            const SizedBox(height: AppSpacing.xl2),
            _SaveButton(),
            const SizedBox(height: AppSpacing.xl2),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category Preview
// ---------------------------------------------------------------------------

class _CategoryPreview extends StatelessWidget {
  const _CategoryPreview({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, size: 36, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Preview',
            style: AppTypography.labelSmall,
          ),
        ],
      ),
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
          _Tab(
            label: 'Expense',
            isSelected: type == TransactionType.expense,
            selectedColor: AppColors.expense,
            onTap: () => onChanged(TransactionType.expense),
          ),
          _Tab(
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

class _Tab extends StatelessWidget {
  const _Tab({
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
              color:
                  isSelected ? Colors.white : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Color Picker
// ---------------------------------------------------------------------------

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<Color> colors;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(colors.length, (i) {
        final isSelected = selected == i;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors[i],
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors[i].withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon Picker
// ---------------------------------------------------------------------------

class _IconPicker extends StatelessWidget {
  const _IconPicker({
    required this.icons,
    required this.color,
    required this.selected,
    required this.onSelected,
  });

  final List<IconData> icons;
  final Color color;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(icons.length, (i) {
        final isSelected = selected == i;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : AppColors.surfaceVariantLight,
              borderRadius: AppRadius.radiusMd,
              border: isSelected ? Border.all(color: color) : null,
            ),
            alignment: Alignment.center,
            child: Icon(
              icons[i],
              size: 22,
              color: isSelected ? color : AppColors.textSecondaryLight,
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Save Button
// ---------------------------------------------------------------------------

class _SaveButton extends StatelessWidget {
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
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.radiusFull,
            ),
          ),
          child: Text(
            'Save Category',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
