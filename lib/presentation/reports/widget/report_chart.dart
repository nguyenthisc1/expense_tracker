import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ReportChart extends StatelessWidget {
  const ReportChart({super.key, this.showIncome = false});

  final bool showIncome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CustomPaint(
        painter: _MonthlyBarChartPainter(showIncome: showIncome),
        size: const Size(double.infinity, 180),
      ),
    );
  }
}

class _MonthlyBarChartPainter extends CustomPainter {
  const _MonthlyBarChartPainter({required this.showIncome});

  final bool showIncome;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const _incomeValues = [0.5, 0.6, 0.55, 0.7, 0.65, 0.75];
  static const _expenseValues = [0.4, 0.5, 0.45, 0.6, 0.5, 0.65];

  @override
  void paint(Canvas canvas, Size size) {
    const labelHeight = 24.0;
    final chartHeight = size.height - labelHeight;
    final groupWidth = size.width / _months.length;
    const barWidth = 10.0;
    const barGap = 4.0;
    const radius = Radius.circular(4);

    final incomePaint = Paint()
      ..color = AppColors.income
      ..style = PaintingStyle.fill;
    final expensePaint = Paint()
      ..color = AppColors.expense.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    final dimIncome = Paint()
      ..color = AppColors.primaryContainer
      ..style = PaintingStyle.fill;
    final dimExpense = Paint()
      ..color = AppColors.expenseLight
      ..style = PaintingStyle.fill;

    for (var i = 0; i < _months.length; i++) {
      final centerX = groupWidth * i + groupWidth / 2;
      final incomeX = centerX - barWidth - barGap / 2;
      final expenseX = centerX + barGap / 2;

      final incomeH = chartHeight * _incomeValues[i];
      final expenseH = chartHeight * _expenseValues[i];

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(incomeX, chartHeight - incomeH, barWidth, incomeH),
          radius,
        ),
        showIncome ? incomePaint : dimIncome,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(expenseX, chartHeight - expenseH, barWidth, expenseH),
          radius,
        ),
        showIncome ? dimExpense : expensePaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: _months[i],
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondaryLight,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(centerX - textPainter.width / 2, chartHeight + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MonthlyBarChartPainter oldDelegate) =>
      oldDelegate.showIncome != showIncome;
}
