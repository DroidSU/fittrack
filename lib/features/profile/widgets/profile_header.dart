import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String fitnessGoal;
  final String? profileImageUrl;
  final VoidCallback onCameraPressed;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.fitnessGoal,
    this.profileImageUrl,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ImageProvider? profileImage;
    if (profileImageUrl != null) {
      if (profileImageUrl!.startsWith('http')) {
        profileImage = NetworkImage(profileImageUrl!);
      } else {
        profileImage = FileImage(File(profileImageUrl!));
      }
    }

    return Stack(
      children: [
        // Premium Gradient Background with abstract shapes
        Container(
          height: 310,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.85),
                const Color(0xFF3F2B96),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Abstract soft circles
              Positioned(
                top: -20,
                left: -20,
                child: _CircleShape(
                  size: 160,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              Positioned(
                bottom: 30,
                right: -30,
                child: _CircleShape(
                  size: 180,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ],
          ),
        ),

        // Content
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.md),

                // Profile Image with Glow and Camera FAB
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.white24,
                        backgroundImage: profileImage,
                        child: profileImage == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 55,
                                color: Colors.white70,
                              )
                            : null,
                      ),
                    ).animate().scale(
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                    GestureDetector(
                      onTap: onCameraPressed,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ).animate().scale(
                          delay: 300.ms,
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // User Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyles.fontWeightBold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.amber,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            fitnessGoal.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: AppTextStyles.fontWeightBold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                const SizedBox(height: AppSpacing.md),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Text(
                    "\"Discipline today, strength forever.\"",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      fontStyle: FontStyle.italic,
                      fontWeight: AppTextStyles.fontWeightMedium,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleShape extends StatelessWidget {
  final double size;
  final Color color;

  const _CircleShape({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
