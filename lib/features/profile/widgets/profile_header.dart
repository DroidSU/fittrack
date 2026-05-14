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
  final VoidCallback onEditPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onCameraPressed;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.fitnessGoal,
    this.profileImageUrl,
    required this.onEditPressed,
    required this.onBackPressed,
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
          height: 380,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
                const Color(0xFF4834D4),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Abstract soft circles
              Positioned(
                top: -50,
                left: -30,
                child: _CircleShape(size: 200, color: Colors.white.withOpacity(0.1)),
              ),
              Positioned(
                bottom: 40,
                right: -60,
                child: _CircleShape(size: 250, color: Colors.white.withOpacity(0.08)),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: _CircleShape(size: 120, color: Colors.white.withOpacity(0.05)),
              ),
            ],
          ),
        ),
        
        // Content
        SafeArea(
          child: Column(
            children: [
              // Top Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onBackPressed,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onEditPressed,
                      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                      label: Text(
                        "Edit Profile",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: AppTextStyles.fontWeightMedium,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Profile Image with Glow and Camera FAB
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white24,
                      backgroundImage: profileImage,
                      child: profileImage == null
                        ? const Icon(Icons.person_rounded, size: 60, color: Colors.white70)
                        : null,
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  
                  GestureDetector(
                    onTap: onCameraPressed,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                    ),
                  ).animate().scale(delay: 400.ms, duration: 400.ms, curve: Curves.easeOutBack),
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
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

              const SizedBox(height: AppSpacing.xs),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          fitnessGoal.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: AppTextStyles.fontWeightBold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

              const SizedBox(height: AppSpacing.md),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  "\"Discipline today, strength forever.\"",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
