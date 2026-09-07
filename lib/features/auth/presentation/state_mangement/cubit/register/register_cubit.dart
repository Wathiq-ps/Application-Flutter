import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/presentation/state_mangement/cubit/register/register_state.dart';
import '../../../../../../core/utils/validators.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  void emailChange(String emailValue) {
    emit(state.copyWith(
      emailOrPhone: emailValue,
      errorMessage: null,
      status: RegisterStatus.initial,
    ));
  }

  void emailValidate() {
    final error = state.emailOrPhone.validateEmail();

    if (error == null) {
      emit(state.copyWith(errorMessage: null, status: RegisterStatus.emailSent));
    } else {
      emit(state.copyWith(errorMessage: error, status: RegisterStatus.error));
    }
  }

  /// Call this right before showing the OTP step, so a leftover
  /// `emailSent` status from the email step doesn't leak into the sheet.
  void prepareOtpStep() {
    emit(state.copyWith(
      otp: '',
      errorMessage: null,
      status: RegisterStatus.initial,
    ));
  }

  void otpChange(String otpValue) {
    emit(state.copyWith(
      otp: otpValue,
      errorMessage: null,
      status: RegisterStatus.initial,
    ));
  }

  Future<void> otpVerify() async {
    emit(state.copyWith(isLoading: true, status: RegisterStatus.initial));

    // TODO: replace with a real repository/usecase call.
    await Future.delayed(const Duration(milliseconds: 400));

    if (state.otp == '2222') {
      emit(state.copyWith(isLoading: false, status: RegisterStatus.otpVerified));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "The code you entered doesn't match. Please try again",
        status: RegisterStatus.error,
      ));
    }
  }
}