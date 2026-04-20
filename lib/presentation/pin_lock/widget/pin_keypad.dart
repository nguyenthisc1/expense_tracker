import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_durations.dart';
import 'package:expense_tracker/core/constants/app_spacing.dart';
import 'package:expense_tracker/core/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Numeric PIN keypad with digits 1–9, 0, and a backspace key.
///
/// Calls [onDigitPressed] with the tapped digit string, and
/// [onBackspacePressed] when the backspace key is tapped.
class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.enabled = true,
  });

  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final bool enabled;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in _rows) ...[
          _KeypadRow(
            keys: row,
            onDigitPressed: onDigitPressed,
            enabled: enabled,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        // Bottom row: empty slot | 0 | backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 72),
            const SizedBox(width: AppSpacing.md),
            _DigitKey(
              digit: '0',
              onPressed: onDigitPressed,
              enabled: enabled,
            ),
            const SizedBox(width: AppSpacing.md),
            _BackspaceKey(
              onPressed: onBackspacePressed,
              enabled: enabled,
            ),
          ],
        ),
      ],
    );
  }
}

class _KeypadRow extends StatelessWidget {
  const _KeypadRow({
    required this.keys,
    required this.onDigitPressed,
    required this.enabled,
  });

  final List<String> keys;
  final ValueChanged<String> onDigitPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          _DigitKey(
            digit: keys[i],
            onPressed: onDigitPressed,
            enabled: enabled,
          ),
        ],
      ],
    );
  }
}

class _DigitKey extends StatelessWidget {
  const _DigitKey({
    required this.digit,
    required this.onPressed,
    required this.enabled,
  });

  final String digit;
  final ValueChanged<String> onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _KeypadButton(
      onTap: enabled ? () => onPressed(digit) : null,
      child: Text(digit, style: AppTypography.headlineLarge),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  const _BackspaceKey({required this.onPressed, required this.enabled});

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _KeypadButton(
      onTap: enabled ? onPressed : null,
      child: const Icon(
        LucideIcons.delete,
        size: 22,
        color: AppColors.textPrimaryLight,
      ),
    );
  }
}

class _KeypadButton extends StatefulWidget {
  const _KeypadButton({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: enabled ? _onTapUp : null,
      onTapCancel: enabled ? _onTapCancel : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppDurations.instant,
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _pressed
              ? AppColors.slate200
              : AppColors.slate100,
          border: Border.all(
            color: AppColors.slate200,
            width: 1.5,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: enabled ? 1.0 : 0.4,
            duration: AppDurations.fast,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
