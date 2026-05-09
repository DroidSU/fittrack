import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/onboarding_placeholder_1.png",
                fit: BoxFit.cover,
                height: 400,
              ),
              Column(
                children: [
                  Text(
                    "Welcome to FitTrack",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: AppTextStyles.fontWeightBold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "Track your workouts, meals and achieve your fitness goals",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                      fontWeight: AppTextStyles.fontWeightNormal,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                        fontSize: AppTextStyles.fontSizeLg,
                        fontWeight: AppTextStyles.fontWeightBold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
