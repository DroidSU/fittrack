import 'package:fittrack/features/auth/providers/auth_provider.dart';
import 'package:fittrack/features/auth/screens/enter_phone_screen.dart';
import 'package:fittrack/features/onboarding/screens/onboarding_flow_screen.dart';
import 'package:fittrack/features/profile/providers/profile_provider.dart';
import 'package:fittrack/screens/main_screen.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return authState.when(
      data: (user) {
        if (user != null) {
          return profileState.when(
            data: (profile) {
              if (profile != null && profile.isOnboardingCompleted) {
                return const MainScreen();
              }
              return const OnboardingFlowScreen();
            },
            loading: () => _LoadingIndicator(isDark: isDark),
            error: (e, s) => _ErrorWidget(message: 'Profile Error: $e', onRetry: () => ref.refresh(profileNotifierProvider)),
          );
        }
        return const EnterPhoneScreen();
      },
      loading: () => _LoadingIndicator(isDark: isDark),
      error: (e, s) => _ErrorWidget(message: 'Authentication Error: $e', onRetry: () => ref.refresh(authStateProvider)),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final bool isDark;
  const _LoadingIndicator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.darkPrimary : AppColors.primary,
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
