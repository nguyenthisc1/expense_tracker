import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/widgets/error_view.dart';
import 'package:expense_tracker/core/widgets/loading_indicator.dart';
import 'package:expense_tracker/presentation/home/cubit/home_cubit.dart';
import 'package:expense_tracker/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';
import '../widget/home_balance_card.dart';
import '../widget/home_recent_transactions.dart';
import '../widget/home_stats_row.dart';
import '../widget/home_weekly_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }
      },
      builder: (BuildContext context, state) {
        if (state.isLoading || state.weeklyReport == null) {
          return const LoadingIndicator(message: 'Loading Infomation...');
        }

        if (state.errorMessage != null && state.weeklyReport == null) {
          return ErrorView(message: state.errorMessage);
        }

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
                    const HomeBalanceCard(),
                    const SizedBox(height: AppSpacing.base),
                    const HomeStatsRow(),
                    const SizedBox(height: AppSpacing.base),
                    const HomeWeeklyChart(),
                    const SizedBox(height: AppSpacing.base),
                    const HomeRecentTransactions(),
                    const SizedBox(height: AppSpacing.xl6),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
