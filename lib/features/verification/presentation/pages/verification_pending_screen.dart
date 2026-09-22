import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/config/routes/routes_names.dart';
import '../../data/models/verification_model.dart';
import '../cubit/verification_cubit.dart';
import '../cubit/verification_state.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  State<VerificationPendingScreen> createState() =>
      _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the latest status as soon as the screen opens.
    context.read<VerificationCubit>().getVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<VerificationCubit, VerificationState>(
        listenWhen: (previous, current) =>
            previous.verification?.status != current.verification?.status,
        listener: (context, state) {
          final kycStatus = state.verification?.status;

          if (kycStatus == VerificationStatus.approved) {
            // TODO: عدّل الراوت حسب اسم شاشة الـ Home/Dashboard عندك
            context.go(RouteNames.addPropertyScreenOne);
          } else if (kycStatus == VerificationStatus.rejected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.verification?.rejectionReason ??
                      'Your verification was rejected',
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // ==========================
            // Background
            // ==========================
            Positioned.fill(
              child: Image.asset(
                'assets/images/onboarding_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: const Color(0xff001B4D).withOpacity(0.55),
              ),
            ),
            // ==========================
            // Card
            // ==========================
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: BlocBuilder<VerificationCubit, VerificationState>(
                    builder: (context, state) {
                      final isRejected =
                          state.verification?.status ==
                          VerificationStatus.rejected;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xff001B4D),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: state.status == RequestStatus.loading
                                ? const Padding(
                                    padding: EdgeInsets.all(24),
                                    child: CircularProgressIndicator(
                                      color: Color(0xff001B4D),
                                    ),
                                  )
                                : Icon(
                                    isRejected
                                        ? Icons.close_rounded
                                        : Icons.hourglass_top_rounded,
                                    color: const Color(0xff001B4D),
                                    size: 40,
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isRejected
                                ? 'Verification Rejected'
                                : 'Verification Pending',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff001B4D),
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 300,
                            child: Text(
                              isRejected
                                  ? (state.verification?.rejectionReason ??
                                        'Your documents were rejected. Please try again.')
                                  : "We're reviewing your documents. This usually takes 1-2 business days. We'll notify you once it's approved.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff001B4D),
                                fontSize: 16,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: isRejected
                                  ? () {
                                      context.read<VerificationCubit>().reset();
                                      context.go(
                                        RouteNames.verifyIdentityScreen,
                                      );
                                    }
                                  : () => context.go(
                                      RouteNames.addPropertyScreenOne,
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff001B4D),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                              ),
                              child: Text(
                                isRejected ? 'Try Again' : 'Back to Home',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
