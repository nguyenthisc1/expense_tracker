enum PinSheetMode { setup, change, disable }

class PinEntryState {
  final PinSheetMode mode;
  final int step;
  final int digits;
  final String enteredPin;
  final String currentPinInput;
  final String newPinInput;
  final bool isLoading;
  final String? errorMessage;
  final bool isCompleted;

  PinEntryState({
    required this.mode,
    required this.step,
    required this.digits,
    required this.enteredPin,
    required this.currentPinInput,
    required this.newPinInput,
    required this.isLoading,
    this.errorMessage,
    required this.isCompleted,
  });

  factory PinEntryState.initial() {
    return PinEntryState(
      isLoading: false,
      errorMessage: null,
      mode: PinSheetMode.setup,
      step: 0,
      digits: 0,
      enteredPin: '',
      currentPinInput: '',
      newPinInput: '',
      isCompleted: false,
    );
  }

  PinEntryState copyWith({
    PinSheetMode? mode,
    int? step,
    int? digits,
    String? enteredPin,
    String? currentPinInput,
    String? newPinInput,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isCompleted,
  }) {
    return PinEntryState(
      mode: mode ?? this.mode,
      step: step ?? this.step,
      digits: digits ?? this.digits,
      enteredPin: enteredPin ?? this.enteredPin,
      currentPinInput: currentPinInput ?? this.currentPinInput,
      newPinInput: newPinInput ?? this.newPinInput,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
