import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../widget/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MoneyFlowAppBar(
        titleText: 'Settings',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.base,
        ),
        children: [
          _ProfileHeader(),
          const SizedBox(height: AppSpacing.base),
          _SettingsSection(
            title: 'GENERAL',
            tiles: [
              SettingsTile(
                icon: LucideIcons.banknote,
                title: 'Currency',
                trailing: _NavTrailing(value: 'USD (\$)'),
                onTap: () {},
              ),
              SettingsTile(
                icon: LucideIcons.globe,
                title: 'Language',
                trailing: _NavTrailing(value: 'English'),
                onTap: () {},
              ),
              SettingsTile(
                icon: LucideIcons.moon,
                title: 'Theme',
                trailing: _NavTrailing(value: 'System'),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsSection(
            title: 'SECURITY',
            tiles: [
              SettingsTile(
                icon: LucideIcons.fingerprintPattern,
                title: 'Biometric Lock',
                trailing: Switch(
                  value: _biometricEnabled,
                  onChanged: (v) => setState(() => _biometricEnabled = v),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              SettingsTile(
                icon: LucideIcons.keyRound,
                title: 'Change PIN',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsSection(
            title: 'NOTIFICATIONS',
            tiles: [
              SettingsTile(
                icon: LucideIcons.bell,
                title: 'Daily Reminders',
                subtitle: 'Morning summary',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
              SettingsTile(
                icon: LucideIcons.triangleAlert,
                title: 'Budget Alerts',
                subtitle: 'At 80% limit',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsSection(
            title: 'DATA & PRIVACY',
            tiles: [
              SettingsTile(
                icon: LucideIcons.download,
                title: 'Export Data (CSV/PDF)',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
              SettingsTile(
                icon: LucideIcons.trash2,
                title: 'Clear All Data',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
              SettingsTile(
                icon: LucideIcons.shieldCheck,
                title: 'Privacy Policy',
                trailing: const Icon(
                  LucideIcons.externalLink,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsSection(
            title: 'SUPPORT',
            tiles: [
              SettingsTile(
                icon: LucideIcons.badgeQuestionMark,
                title: 'Help Center',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
              SettingsTile(
                icon: LucideIcons.star,
                title: 'Rate the App',
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.textSecondaryLight,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _LogoutButton(),
          const SizedBox(height: AppSpacing.xl),
          _AppFooter(),
          const SizedBox(height: AppSpacing.xl2),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile Header
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              'JS',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Julian Sterling', style: AppTypography.headlineSmall),
                const SizedBox(height: 2),
                Text(
                  'julian.sterling@privatebank.com',
                  style: AppTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              LucideIcons.pencil,
              size: 18,
              color: AppColors.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings Section
// ---------------------------------------------------------------------------

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.tiles});

  final String title;
  final List<SettingsTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondaryLight,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.sm,
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _NavTrailing extends StatelessWidget {
  const _NavTrailing({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        const Icon(
          LucideIcons.chevronRight,
          size: 18,
          color: AppColors.textSecondaryLight,
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(LucideIcons.logOut, size: 18),
        label: const Text('Logout'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.radiusFull,
          ),
        ),
      ),
    );
  }
}

class _AppFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'MoneyFlow Premium',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Version 2.4.1 (Build 890)',
          style: AppTypography.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
