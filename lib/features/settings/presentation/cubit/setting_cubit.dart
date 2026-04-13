import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';
import 'package:expense_tracker/features/settings/domain/usecase/get_setting_usecase.dart';
import 'package:expense_tracker/features/settings/domain/usecase/update_setting_usecase.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUsecase _getSettingsUsecase;
  final UpdateSettingsUsecase _updateSettingsUsecase;

  SettingsCubit({
    required GetSettingsUsecase getSettingsUsecase,
    required UpdateSettingsUsecase updateSettingsUsecase,
  }) : _getSettingsUsecase = getSettingsUsecase,
       _updateSettingsUsecase = updateSettingsUsecase,
       super(SettingsState.initial());

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final settings = await _getSettingsUsecase();

      emit(
        state.copyWith(isLoading: false, settings: settings, clearError: true),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> saveSettings(AppSettingsEntity settings) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final saved = await _updateSettingsUsecase(settings);

      emit(state.copyWith(isLoading: false, settings: saved, clearError: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
