enum RegisterStatus { initial, error, emailSent, otpVerified }

class RegisterState {
  final String emailOrPhone;
  final String otp;
  final String? errorMessage;
  final RegisterStatus status;
  final bool isLoading;

  const RegisterState({
    this.emailOrPhone = '',
    this.otp = '',
    this.errorMessage,
    this.status = RegisterStatus.initial,
    this.isLoading = false,
  });

  RegisterState copyWith({
    String? emailOrPhone,
    String? otp,
    String? errorMessage,
    RegisterStatus? status,
    bool? isLoading,
  }) {
    return RegisterState(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      otp: otp ?? this.otp,
      errorMessage: errorMessage,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}