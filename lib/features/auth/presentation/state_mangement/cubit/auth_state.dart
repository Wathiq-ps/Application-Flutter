import '../../../domain/entities/auth_mode.dart';
import '../../../domain/entities/user_entitiy.dart';

enum AuthStatus {
  initial,
  otpRequested,
  validationError,
  requestError,
  otpValidationError,
  otpBackendError,
  otpVerified,
}

class AuthState {
  final AuthMode mode;
 final String emailOrPhone;
  final String otp;
  final String? errorMessage;
  final AuthStatus status;
  final bool isLoading;
  final UserEntity? user;

  const AuthState({
    required this.mode,
    this.emailOrPhone = '',
    this.otp = '',
    this.errorMessage,
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.user,
  });

  AuthState copyWith({
    String? emailOrPhone,
    String? otp,
    String? errorMessage,
    AuthStatus? status,
    bool? isLoading,
    UserEntity? user,
  }) {
    return AuthState(
      mode: mode,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      otp: otp ?? this.otp,
      errorMessage: errorMessage,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

class AState{
  String a ;
  AState(this.a);
}