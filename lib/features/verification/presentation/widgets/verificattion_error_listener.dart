import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../cubit/verification_cubit.dart';
import '../cubit/verification_state.dart';

class VerificationErrorListener extends StatelessWidget {
  const VerificationErrorListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCubit, VerificationState>(
      listenWhen: (previous, current) =>
      previous.status != current.status &&
          current.status == RequestStatus.failure &&
          current.errorMessage != null,
      listener: (context, state) {
        AppTopSnackBar.show(
          context,
          title: AppStrings.verificationFailed,
          message: state.errorMessage!,
          prefixIcon: AppIcons.error,
        );
      },
      child: child,
    );
  }
}