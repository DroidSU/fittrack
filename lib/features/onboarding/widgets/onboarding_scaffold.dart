import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_spacing.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'onboarding_progress.dart';

class OnboardingScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget action;
  final double progress;
  final VoidCallback? onBack;

  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.action,
    required this.progress,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: onBack != null
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
                onPressed: onBack,
              )
            : null,
        title: OnboardingProgress(progress: progress),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      title,
                      style: AppTextStyles.h1.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: child,
                    ),
                    const Spacer(flex: 3),
                    action,
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
