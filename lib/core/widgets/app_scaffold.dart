import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// Base scaffold for MoneyFlow screens.
///
/// Provides consistent background color, safe area handling,
/// and optional padding. Prefer this over raw [Scaffold] in feature pages.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.padding,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  /// Optional inner padding for the body content.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveBackground =
        backgroundColor ?? Theme.of(context).colorScheme.surface;

    Widget content = body;
    if (padding != null) {
      content = Padding(padding: padding!, child: body);
    }

    return Scaffold(
      backgroundColor: effectiveBackground,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  /// Convenience factory for screens with standard page padding.
  factory AppScaffold.padded({
    Key? key,
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
    bool resizeToAvoidBottomInset = true,
  }) {
    return AppScaffold(
      key: key,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.pageVertical,
      ),
      body: body,
    );
  }
}

/// Standard MoneyFlow [AppBar] with consistent styling.
class MoneyFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MoneyFlowAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
  }) : assert(
          title == null || titleText == null,
          'Provide either title or titleText, not both.',
        );

  final Widget? title;
  final String? titleText;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveTitle =
        title ?? (titleText != null ? Text(titleText!) : null);

    return AppBar(
      title: effectiveTitle,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.surface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Sliver AppBar variant for scrollable screens.
class MoneyFlowSliverAppBar extends StatelessWidget {
  const MoneyFlowSliverAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.expandedHeight,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
  });

  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final effectiveTitle =
        title ?? (titleText != null ? Text(titleText!) : null);

    return SliverAppBar(
      title: effectiveTitle,
      actions: actions,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }
}
