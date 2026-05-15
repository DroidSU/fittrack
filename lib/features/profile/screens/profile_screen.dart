import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../analytics/providers/dashboard_analytics_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../meals/providers/meal_notifier.dart';
import '../../workouts/providers/workout_notifier.dart';
import '../providers/profile_provider.dart';
import '../widgets/achievement_strip.dart';
import '../widgets/metric_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_list_tile.dart';
import '../widgets/profile_settings_group.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authStateProvider).value;
    final streak = ref.watch(dashboardStreakProvider);
    final mealsCount = ref.watch(mealProvider).value?.length ?? 0;
    final workoutsCount = ref.watch(workoutsProvider).value?.length ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text("Profile not found"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. HERO HEADER SECTION
                      ProfileHeader(
                        name: profile.name,
                        fitnessGoal: profile.fitnessGoal,
                        profileImageUrl: profile.profileImageUrl,
                        onCameraPressed: () => ref
                            .read(profileNotifierProvider.notifier)
                            .uploadProfileImage(),
                      ),

                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: AppSpacing.lg),

                                // 2. COMPACT METRICS ROW
                                Row(
                                      children: [
                                        Expanded(
                                          child: MetricCard(
                                            icon: Icons.straighten_rounded,
                                            label: "Height",
                                            value:
                                                "${profile.height.toInt()} cm",
                                            iconColor: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: MetricCard(
                                            icon: Icons.monitor_weight_outlined,
                                            label: "Weight",
                                            value:
                                                "${profile.currentWeight.toInt()} kg",
                                            iconColor: Colors.indigo,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: MetricCard(
                                            icon: Icons.track_changes_rounded,
                                            label: "Goal",
                                            value: profile.fitnessGoal,
                                            iconColor: Colors.teal,
                                          ),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(delay: 100.ms)
                                    .slideX(begin: 0.1),

                                const SizedBox(height: AppSpacing.lg),

                                // 3. ACHIEVEMENTS ROW
                                AchievementStrip(
                                      streakDays: streak,
                                      workoutCount: workoutsCount,
                                      mealsLogged: mealsCount,
                                    )
                                    .animate()
                                    .fadeIn(delay: 200.ms)
                                    .slideX(begin: -0.1),

                                const SizedBox(height: AppSpacing.xl),

                                // 4. PREFERENCES SECTION
                                ProfileSettingsGroup(
                                      title: "Preferences",
                                      children: [
                                        ProfileListTile(
                                          icon:
                                              Icons.notifications_none_rounded,
                                          iconColor: Colors.indigo,
                                          title: "Notifications",
                                          onTap: () {},
                                        ),
                                        ProfileListTile(
                                          icon: Icons.straighten_rounded,
                                          iconColor: Colors.deepPurpleAccent,
                                          title: "Units",
                                          trailingValue: "kg, cm",
                                          onTap: () {},
                                        ),
                                        ProfileListTile(
                                          icon: Icons.dark_mode_outlined,
                                          iconColor: Colors.indigo,
                                          title: "Theme",
                                          trailingValue: "Dark",
                                          onTap: () {},
                                        ),
                                        ProfileListTile(
                                          icon: Icons.verified_user_outlined,
                                          iconColor: Colors.indigo,
                                          title: "Privacy",
                                          showDivider: false,
                                          onTap: () {},
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(delay: 300.ms)
                                    .slideY(begin: 0.1),

                                const SizedBox(height: AppSpacing.lg),

                                // 5. ACCOUNT SECTION
                                ProfileSettingsGroup(
                                      title: "Account",
                                      children: [
                                        ProfileListTile(
                                          icon: Icons.phone_outlined,
                                          iconColor: Colors.indigo,
                                          title: "Phone Number",
                                          subtitle:
                                              authState?.phoneNumber ??
                                              "Not provided",
                                          trailing: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Verified",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                        ProfileListTile(
                                          icon: Icons.logout_rounded,
                                          iconColor: AppColors.error,
                                          title: "Logout",
                                          titleColor: AppColors.error,
                                          subtitle: "Sign out of your account",
                                          showDivider: false,
                                          onTap: () =>
                                              _showLogoutDialog(context, ref),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(delay: 400.ms)
                                    .slideY(begin: 0.1),

                                const SizedBox(height: AppSpacing.xl * 2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).logout();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
