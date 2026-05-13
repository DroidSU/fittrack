import 'dart:async';

import 'package:fittrack/features/auth/widgets/wave_clipper.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_spacing.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      body: Stack(
        children: [
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center_rounded,
                  size: 80,
                  color: primaryColor,
                )
                .animate()
                .fade(duration: 800.ms)
                .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: AppSpacing.lg),
                
                Text(
                  'FitTrack',
                  style: AppTextStyles.h1.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                )
                .animate()
                .fade(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: AppSpacing.xs),
                
                Text(
                  'Track. Train. Improve.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                )
                .animate()
                .fade(delay: 600.ms, duration: 600.ms),
                
                const SizedBox(height: AppSpacing.xl * 2),
                
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      primaryColor.withOpacity(0.5),
                    ),
                  ),
                ).animate().fade(delay: 1000.ms),
              ],
            ),
          ),
          
          // Bottom Wave Shapes
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primaryColor.withOpacity(0.1),
                        primaryColor.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate().fade(duration: 1200.ms).slideY(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }
}
