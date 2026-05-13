import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/auth/widgets/auth_button.dart';
import 'package:fittrack/features/auth/widgets/auth_card.dart';
import 'package:fittrack/features/auth/widgets/auth_header.dart';
import 'package:fittrack/features/auth/widgets/auth_phone_field.dart';
import 'package:fittrack/features/auth/widgets/auth_placeholder_banner.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnterPhoneScreen extends ConsumerStatefulWidget {
  const EnterPhoneScreen({super.key});

  @override
  ConsumerState<EnterPhoneScreen> createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends ConsumerState<EnterPhoneScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length >= 10) {
      ref.read(authNotifierProvider.notifier).sendOtp('+91$phone');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(authNotifierProvider.select((s) => s.codeSent), (previous, next) {
      if (next) {
        context.push('/otp');
      }
    });

    ref.listen(authNotifierProvider.select((s) => s.error), (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.redAccent),
        );
        ref.read(authNotifierProvider.notifier).resetError();
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AuthPlaceholderBanner(
              icon: Icons.smartphone_rounded,
              height: MediaQuery.of(context).size.height * 0.45,
            ).animate().fade(duration: 800.ms),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'Enter Mobile Number',
                    subtitle: "We'll send you a verification code",
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  AuthPhoneField(
                    controller: _phoneController,
                    label: 'Mobile Number',
                  ).animate().fade(delay: 400.ms).slideX(begin: 0.05, end: 0),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary).withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'We will never share your number with anyone.',
                          style: TextStyle(
                            fontSize: 12,
                            color: (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary).withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 500.ms),
                  
                  const Spacer(flex: 2),
                  AuthButton(
                    text: 'Send OTP',
                    isLoading: authState.isLoading,
                    onPressed: _onSendOtp,
                  ).animate().fade(delay: 600.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkPrimary : AppColors.primary,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkPrimary : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(delay: 700.ms),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
