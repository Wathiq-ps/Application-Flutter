import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/strings.dart';
import '../../../../../core/error/auth_exception.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../domain/entities/auth_mode.dart';
import '../../../domain/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({
    required AuthMode mode,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState(mode: mode));

  void emailChange(String emailValue) {
    emit(state.copyWith(
      emailOrPhone: emailValue,
      errorMessage: null,
      status: AuthStatus.initial,
    ));
  }

  Future<void> emailValidate() async {
    final error = state.emailOrPhone.validateEmail();
    if (error != null) {
      emit(state.copyWith(errorMessage: error, status: AuthStatus.validationError));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, status: AuthStatus.initial));

    try {
      await _authRepository.requestOtp(
        email: state.emailOrPhone,
        status: state.mode.apiValue,
      );
      emit(state.copyWith(isLoading: false, errorMessage: null, status: AuthStatus.otpRequested));
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message, status: AuthStatus.requestError));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.somethingWentWrong,
        status: AuthStatus.requestError,
      ));
    }
  }

  void prepareOtpStep() {
    emit(state.copyWith(otp: '', errorMessage: null, status: AuthStatus.initial));
  }

  void otpChange(String otpValue) {
    emit(state.copyWith(otp: otpValue, errorMessage: null, status: AuthStatus.initial));
  }

  Future<void> otpVerify() async {
    if (state.otp.length < 6) {
      emit(state.copyWith(
        errorMessage: AppStrings.pleaseEnterFullOtp,
        status: AuthStatus.otpValidationError,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, status: AuthStatus.initial));

    try {
      final result = await _authRepository.verifyOtp(
        email: state.emailOrPhone,
        code: state.otp,
      );
      emit(state.copyWith(isLoading: false, status: AuthStatus.otpVerified, user: result.user));
    } on AuthException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        status: AuthStatus.otpBackendError,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.somethingWentWrong,
        status: AuthStatus.otpBackendError,
      ));
    }
  }
}
