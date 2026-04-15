import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';
import '../../transactions/widget/transaction_list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addTransaction),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(LucideIcons.plus),
        label: const Text('Quick Add'),
      ),
      body: CustomScrollView(
        slivers: [
          MoneyFlowSliverAppBar(titleText: 'MoneyFlow'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.base,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _BalanceCard(),
                const SizedBox(height: AppSpacing.base),
                _StatsRow(),
                const SizedBox(height: AppSpacing.base),
                _WeeklyChart(),
                const SizedBox(height: AppSpacing.base),
                _RecentTransactions(),
                const SizedBox(height: AppSpacing.xl6),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Balance Card
// ---------------------------------------------------------------------------

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '\$12,450.00',
            style: AppTypography.displayLarge,
          ),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              _BalanceActionButton(
                icon: LucideIcons.send,
                label: 'Send',
              ),
              const SizedBox(width: AppSpacing.md),
              _BalanceActionButton(
                icon: LucideIcons.download,
                label: 'Deposit',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceActionButton extends StatelessWidget {
  const _BalanceActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stats Row
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: LucideIcons.arrowDown,
            label: 'Income',
            amount: '\$4,200.50',
            iconColor: AppColors.income,
            backgroundColor: AppColors.primaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            icon: LucideIcons.arrowUp,
            label: 'Expenses',
            amount: '\$2,140.20',
            iconColor: AppColors.expense,
            backgroundColor: AppColors.expenseLight,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final String amount;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount,
            style: AppTypography.amountSmall.copyWith(color: iconColor),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly Chart
// ---------------------------------------------------------------------------

class _WeeklyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expense Summary', style: AppTypography.titleMedium),
          const SizedBox(height: 2),
          Text(
            'Weekly outflow visualization',
            style: AppTypography.labelSmall,
          ),
          const SizedBox(height: AppSpacing.base),
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _WeeklyBarChartPainter(),
              size: const Size(double.infinity, 120),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyBarChartPainter extends CustomPainter {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _values = [0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.45];

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final dimPaint = Paint()
      ..color = AppColors.primaryContainer
      ..style = PaintingStyle.fill;

    const labelHeight = 20.0;
    final chartHeight = size.height - labelHeight;
    final barWidth = size.width / (_days.length * 2);
    const radius = Radius.circular(4);

    for (var i = 0; i < _days.length; i++) {
      final x = i * (size.width / _days.length) + barWidth / 2;
      final barH = chartHeight * _values[i];
      final y = chartHeight - barH;

      final isHighlighted = i == 3;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barH),
          radius,
        ),
        isHighlighted ? barPaint : dimPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: _days[i],
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondaryLight,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, chartHeight + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Recent Transactions
// ---------------------------------------------------------------------------

class _RecentTransactions extends StatelessWidget {
  static final _items = [
    _TransactionData(
      title: 'Artisan Bakery',
      subtitle: 'Food & Dining • Today',
      icon: LucideIcons.utensils,
      iconColor: AppColors.emerald500,
      amount: '\$24.50',
      isIncome: false,
    ),
    _TransactionData(
      title: 'Modern Clothier',
      subtitle: 'Shopping • Yesterday',
      icon: LucideIcons.shoppingBag,
      iconColor: AppColors.slate600,
      amount: '\$120.00',
      isIncome: false,
    ),
    _TransactionData(
      title: 'Freelance Project',
      subtitle: 'Income • 2 days ago',
      icon: LucideIcons.banknote,
      iconColor: AppColors.emerald500,
      amount: '\$850.00',
      isIncome: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: AppTypography.titleMedium),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...List.generate(_items.length, (i) {
          final item = _items[i];
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < _items.length - 1 ? AppSpacing.sm : 0,
            ),
            child: TransactionListItem(
              title: item.title,
              subtitle: item.subtitle,
              icon: item.icon,
              iconColor: item.iconColor,
              amount: item.amount,
              isIncome: item.isIncome,
            ),
          );
        }),
      ],
    );
  }
}

class _TransactionData {
  const _TransactionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String amount;
  final bool isIncome;
}
