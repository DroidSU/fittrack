import 'dart:async';

import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/auth/widgets/auth_button.dart';
import 'package:fittrack/features/auth/widgets/auth_card.dart';
import 'package:fittrack/features/auth/widgets/auth_header.dart';
import 'package:fittrack/features/auth/widgets/auth_placeholder_banner.dart';
import 'package:fittrack/features/auth/widgets/otp_input.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_spacing.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otp = '';
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timerSeconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  void _onVerify() {
    if (_otp.length == 6) {
      ref.read(authNotifierProvider.notifier).verifyOtp(_otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final viewInsets = MediaQuery.of(context).viewInsets;

    ref.listen(authNotifierProvider.select((s) => s.isVerified), (previous, next) {
      if (next) {
        context.go('/auth-success');
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            size: 22,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // Prevents annoying bounce on short screens
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Responsive Illustration with height constraints
                        AuthPlaceholderBanner(
                          icon: Icons.mark_email_read_rounded,
                          height: (constraints.maxHeight * 0.28).clamp(160.0, 280.0),
                        ),

                        // Expanded AuthCard fills the remaining height or grows with content
                        Expanded(
                          child: AuthCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const AuthHeader(
                                  title: 'Verify OTP',
                                  subtitle: 'Enter the 6-digit code sent to',
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                
                                // Phone number & Edit action - Use Wrap for responsiveness
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      authState.phoneNumber ?? "",
                                      style: AppTextStyles.bodyLg.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppSpacing.xl),
                                
                                // OTP Input - Now uses Flexible boxes internally
                                OtpInput(
                                  onCompleted: (otp) {
                                    setState(() => _otp = otp);
                                    _onVerify();
                                  },
                                ),
                                
                                const SizedBox(height: AppSpacing.xl),
                                
                                // Resend Section
                                Center(
                                  child: _timerSeconds > 0
                                      ? Text(
                                          'Resend OTP in 00:${_timerSeconds.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            if (authState.phoneNumber != null) {
                                              ref.read(authNotifierProvider.notifier).sendOtp(authState.phoneNumber!);
                                              _startTimer();
                                            }
                                          },
                                          child: Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                ),
                                
                                // Spacer ensures the button stays at the bottom when space is available
                                const Spacer(),
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Verify Button
                                AuthButton(
                                  text: 'Verify OTP',
                                  isLoading: authState.isLoading,
                                  onPressed: _onVerify,
                                ),
                                
                                // Adaptive bottom padding for keyboard and safe area
                                SizedBox(
                                  height: viewInsets.bottom > 0 
                                    ? AppSpacing.md 
                                    : AppSpacing.xl,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
