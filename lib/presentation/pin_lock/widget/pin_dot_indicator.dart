import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_durations.dart';
import 'package:expense_tracker/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

/// Displays 4 animated dots representing the current PIN input progress.
///
/// Filled dots indicate entered digits. The [hasError] flag turns all dots red
/// to signal an incorrect entry before resetting.
class PinDotIndicator extends StatelessWidget {
  const PinDotIndicator({
    super.key,
    required this.filledCount,
    this.hasError = false,
    this.dotSize = 16.0,
  }) : assert(filledCount >= 0 && filledCount <= 4);

  final int filledCount;
  final bool hasError;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final filled = index < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: _PinDot(filled: filled, hasError: hasError, size: dotSize),
        );
      }),
    );
  }
}

class _PinDot extends StatelessWidget {
  const _PinDot({
    required this.filled,
    required this.hasError,
    required this.size,
  });

  final bool filled;
  final bool hasError;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    if (hasError) {
      dotColor = AppColors.error;
    } else if (filled) {
      dotColor = AppColors.primary;
    } else {
      dotColor = Colors.transparent;
    }

    return AnimatedContainer(
      duration: AppDurations.fast,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
        border: Border.all(
          color: hasError
              ? AppColors.error
              : filled
              ? AppColors.primary
              : AppColors.slate400,
          width: 2,
        ),
      ),
    );
  }
}
