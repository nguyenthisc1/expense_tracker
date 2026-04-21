import 'package:expense_tracker/presentation/pin_lock/cubit/pin_entry_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinEntryCubit extends Cubit<PinEntryState> {
  PinEntryCubit() : super(PinEntryState.initial());

  static const int _pinLength = 4;

  void initialize(PinSheetMode mode) {
    emit(PinEntryState.initial().copyWith(mode: mode, clearError: true));
  }

  void onDigit(String digit) {
    if (state.isLoading || state.enteredPin.length >= _pinLength) return;

    final nextPin = '${state.enteredPin}$digit';
    final nextState = state.copyWith(
      enteredPin: nextPin,
      digits: nextPin.length,
      clearError: true,
      isCompleted: false,
    );
    emit(nextState);

    if (nextPin.length == _pinLength) {
      completeEntry();
    }
  }

  void onBackspace() {
    if (state.isLoading || state.enteredPin.isEmpty) return;

    final nextPin = state.enteredPin.substring(0, state.enteredPin.length - 1);
    emit(
      state.copyWith(
        enteredPin: nextPin,
        digits: nextPin.length,
        clearError: true,
        isCompleted: false,
      ),
    );
  }

  void completeEntry() {
    final entered = state.enteredPin;

    switch (state.mode) {
      case PinSheetMode.setup:
        _handleSetup(entered);
        break;
      case PinSheetMode.change:
        _handleChange(entered);
        break;
      case PinSheetMode.disable:
        _handleDisable(entered);
        break;
    }
  }

  void resetError() {
    emit(state.copyWith(clearError: true));
  }

  void showError(
    String message, {
    int? step,
    String? currentPinInput,
    String? newPinInput,
  }) {
    emit(
      state.copyWith(
        step: step ?? state.step,
        currentPinInput: currentPinInput ?? state.currentPinInput,
        newPinInput: newPinInput ?? state.newPinInput,
        enteredPin: '',
        digits: 0,
        errorMessage: message,
        isCompleted: false,
      ),
    );
  }

  void _handleSetup(String entered) {
    if (state.step == 0) {
      emit(
        state.copyWith(
          step: 1,
          newPinInput: entered,
          enteredPin: '',
          digits: 0,
          clearError: true,
        ),
      );
      return;
    }

    if (entered == state.newPinInput) {
      emit(
        state.copyWith(
          enteredPin: entered,
          digits: entered.length,
          isCompleted: true,
          clearError: true,
        ),
      );
      return;
    }

    showError('PINs do not match. Try again.', step: 0, newPinInput: '');
  }

  void _handleChange(String entered) {
    if (state.step == 0) {
      emit(
        state.copyWith(
          step: 1,
          currentPinInput: entered,
          enteredPin: '',
          digits: 0,
          clearError: true,
        ),
      );
      return;
    }

    if (state.step == 1) {
      emit(
        state.copyWith(
          step: 2,
          newPinInput: entered,
          enteredPin: '',
          digits: 0,
          clearError: true,
        ),
      );
      if (state.currentPinInput == state.newPinInput) {
        showError(
          'Old Pin cant not same new Pin. Try again.',
          step: 1,
          newPinInput: '',
        );
      }
      return;
    }

    if (entered == state.newPinInput) {
      emit(
        state.copyWith(
          enteredPin: entered,
          digits: entered.length,
          isCompleted: true,
          clearError: true,
        ),
      );
      return;
    }

    showError('PINs do not match. Try again.', step: 1, newPinInput: '');
  }

  void _handleDisable(String entered) {
    emit(
      state.copyWith(
        currentPinInput: entered,
        enteredPin: entered,
        digits: entered.length,
        isCompleted: true,
        clearError: true,
      ),
    );
  }
}
