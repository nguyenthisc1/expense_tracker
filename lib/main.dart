import 'package:expense_tracker/core/seed/seed_runner.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/widget/app_lock_gate.dart';
import 'package:expense_tracker/presentation/settings/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await runInitialSeed();
  runApp(const MoneyFlowApp());
}

class MoneyFlowApp extends StatelessWidget {
  const MoneyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (_) => sl<SettingsCubit>()..loadSettings(),
        ),
        BlocProvider<AppPinLockSettingCubit>(
          create: (_) => sl<AppPinLockSettingCubit>()..loadAppLockSettings(),
        ),
        BlocProvider<AppLockCubit>(
          create: (_) => sl<AppLockCubit>()..initialize(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MoneyFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: AppPages.router,
        builder: (context, child) {
          return AppLockGate(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
