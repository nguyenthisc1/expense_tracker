import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_durations.dart';
import 'package:expense_tracker/core/constants/app_icons.dart';
import 'package:expense_tracker/core/constants/app_spacing.dart';
import 'package:expense_tracker/core/constants/app_typography.dart';
import 'package:expense_tracker/presentation/pin_lock/widget/pin_dot_indicator.dart';
import 'package:expense_tracker/presentation/pin_lock/widget/pin_keypad.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Full-screen lock screen shown when the app is locked with a PIN.
///
/// When verification succeeds, [onUnlocked] is invoked when provided. In the
/// app-lock gate flow this page is shown as an overlay, so it does not attempt
/// to pop a route on its own.
class PinLockPage extends StatefulWidget {
  const PinLockPage({super.key, this.onUnlocked, this.onVerifyPin});

  final VoidCallback? onUnlocked;
  final Future<bool> Function(String pin)? onVerifyPin;

  @override
  State<PinLockPage> createState() => _PinLockPageState();
}

class _PinLockPageState extends State<PinLockPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  static const int _pinLength = 4;

  List<int> _digits = [];
  bool _hasError = false;
  String? _errorMessage;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: AppDurations.standard,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_isVerifying || _digits.length >= _pinLength) return;
    setState(() {
      _digits.add(int.parse(digit));
      _hasError = false;
      _errorMessage = null;
    });
    if (_digits.length == _pinLength) {
      Future.delayed(const Duration(milliseconds: 200), _verifyPin);
    }
  }

  void _onBackspace() {
    if (_isVerifying || _digits.isEmpty) return;
    setState(() {
      _digits.removeLast();
      _hasError = false;
      _errorMessage = null;
    });
  }

  Future<void> _verifyPin() async {
    if (!mounted) return;
    setState(() => _isVerifying = true);

    final entered = _digits.join();
    final isValid = widget.onVerifyPin != null
        ? await widget.onVerifyPin!(entered)
        : entered != '0000';
    if (!mounted) return;

    if (!isValid) {
      setState(() {
        _isVerifying = false;
        _hasError = true;
        _errorMessage = 'Incorrect PIN. Try again.';
        _digits = [];
      });
      _shakeController.forward(from: 0);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _hasError = false;
            _errorMessage = null;
          });
        }
      });
    } else {
      setState(() => _isVerifying = false);
      if (widget.onUnlocked != null) {
        widget.onUnlocked!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // App icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.xl),
              ),
              child: const Icon(
                LucideIcons.shieldCheck,
                size: AppIcons.xl3,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Enter PIN', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Enter your PIN to access MoneyFlow',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Dot indicator with shake
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              ),
              child: PinDotIndicator(
                filledCount: _digits.length,
                hasError: _hasError,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Error message
            AnimatedSwitcher(
              duration: AppDurations.fast,
              child: _hasError && _errorMessage != null
                  ? Text(
                      _errorMessage!,
                      key: const ValueKey('error'),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(key: ValueKey('no-error'), height: 18),
            ),
            const Spacer(),
            // Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
              child: PinKeypad(
                onDigitPressed: _onDigit,
                onBackspacePressed: _onBackspace,
                enabled: !_isVerifying,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Loading indicator
            AnimatedOpacity(
              opacity: _isVerifying ? 1.0 : 0.0,
              duration: AppDurations.fast,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
