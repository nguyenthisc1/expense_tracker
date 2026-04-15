import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeHeader(),
              const Spacer(),
              _HeroSection(),
              const SizedBox(height: AppSpacing.xl3),
              _ActionButtons(
                onGetStarted: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: AppSpacing.xl2),
              _TrustBadges(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to MoneyFlow',
          style: AppTypography.labelSmall.copyWith(
            letterSpacing: 1.2,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text(
              'MoneyFlow',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.primary,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.radiusMd,
              ),
              child: const Icon(
                LucideIcons.trendingUp,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: AppRadius.radiusFull,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.trendingUp,
                size: 12,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Global Assets +12.4%',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Wealth,\nIn Flow.',
          style: AppTypography.displayLarge.copyWith(
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Experience the tranquility of high-end financial management. Simplified tracking for the modern curator.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondaryLight,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: AppRadius.radiusFull,
          ),
          child: ElevatedButton(
            onPressed: onGetStarted,
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
              'Get Started',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: onGetStarted,
          child: Text(
            'I already have an account',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrustBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TrustBadge(
          icon: LucideIcons.shieldCheck,
          label: 'Bank-Grade Security',
        ),
        const SizedBox(width: AppSpacing.md),
        _TrustBadge(
          icon: LucideIcons.lock,
          label: 'Private & Encrypted',
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondaryLight),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
