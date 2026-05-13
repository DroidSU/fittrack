import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/auth/widgets/auth_button.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_spacing.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthSuccessScreen extends ConsumerWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                // Background Decorative Particles
                ...List.generate(6, (index) {
                  final size = 10.0 + (index * 4);
                  return Positioned(
                    top: 100.0 + (index * 120),
                    left: (index % 2 == 0) ? 40 : null,
                    right: (index % 2 != 0) ? 40 : null,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .moveY(begin: 0, end: 20, duration: (2000 + (index * 500)).ms)
                     .fade(begin: 0.1, end: 0.5),
                  );
                }),

                Positioned.fill(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          
                          // Animated Success Indicator
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ).animate(onPlay: (controller) => controller.repeat())
                                .scale(duration: 2500.ms, begin: const Offset(1, 1), end: const Offset(1.3, 1.3), curve: Curves.easeInOut)
                                .fade(duration: 2500.ms, begin: 0.5, end: 0.05),
                              
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                            ],
                          ),
                          
                          const SizedBox(height: AppSpacing.xl * 2),
                          
                          Text(
                            "You're All Set!",
                            style: AppTextStyles.h1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ).animate().fade(delay: 400.ms).slideY(begin: 0.2, end: 0),
                          
                          const SizedBox(height: AppSpacing.sm),
                          
                          Text(
                            "Your number has been verified successfully.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMd.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          ).animate().fade(delay: 600.ms).slideY(begin: 0.2, end: 0),
                          
                          const Spacer(),
                          const SizedBox(height: AppSpacing.lg),
                          
                          AuthButton(
                            text: 'Continue to App',
                            onPressed: () {
                              ref.read(authNotifierProvider.notifier).resetVerification();
                              context.go('/');
                            },
                          ).animate().fade(delay: 800.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
                          
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
