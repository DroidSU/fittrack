import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../features/analytics/providers/dashboard_analytics_provider.dart';
import '../features/meals/providers/meal_notifier.dart';
import '../features/profile/providers/profile_provider.dart';
import '../features/workouts/providers/workout_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/action_dock.dart';
import '../widgets/empty_state_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mealsAsync = ref.watch(mealProvider);
    final workoutsAsync = ref.watch(workoutsProvider);
    
    final totalProtein = ref.watch(totalProteinProvider);
    const targetProtein = 150.0;
    final proteinPercentage = (totalProtein / targetProtein).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: mealsAsync.when(
          data: (_) => workoutsAsync.when(
            data: (_) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DashboardHeader(),
                  const SizedBox(height: AppSpacing.md),
                  _ProteinGoalHeroCard(
                    current: totalProtein,
                    target: targetProtein,
                    percentage: proteinPercentage,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
                  const SizedBox(height: AppSpacing.md),
                  const _WeeklyProteinMiniChart().animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: AppSpacing.md),
                  const _CompactStreakAndGoalCard().animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: AppSpacing.lg),
                  const _RecentActivitySection().animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 120), // Padding for FAB
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButton: ActionDock(
        onLogMeal: () => context.push("/add-meal"),
        onLogWorkout: () => context.push("/add-workout"),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _DashboardHeader extends ConsumerWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(profileNotifierProvider);
    final userName = profileAsync.value?.name ?? "User";
    final profileImageUrl = profileAsync.value?.profileImageUrl;

    ImageProvider? profileImage;
    if (profileImageUrl != null) {
      if (profileImageUrl.startsWith('http')) {
        profileImage = NetworkImage(profileImageUrl);
      } else {
        profileImage = FileImage(File(profileImageUrl));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back,",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.hintColor.withOpacity(0.5),
                  fontWeight: AppTextStyles.fontWeightMedium,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: AppTextStyles.fontWeightBold,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        GestureDetector(
          onTap: () => context.push("/profile"),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.surface,
              backgroundImage: profileImage,
              child: profileImage == null
                ? const Icon(Icons.person_rounded, color: AppColors.primary)
                : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProteinGoalHeroCard extends StatelessWidget {
  final double current;
  final double target;
  final double percentage;

  const _ProteinGoalHeroCard({
    required this.current,
    required this.target,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 85,
                    width: 85,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 10,
                      backgroundColor: AppColors.primary.withOpacity(0.08),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    "${(percentage * 100).toInt()}%",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: AppTextStyles.fontWeightBold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily Protein",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.fontWeightBold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${current.toInt()}g",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: AppTextStyles.fontWeightBold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: " / ${target.toInt()}g goal",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(target - current).clamp(0, target).toInt()}g remaining",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.hintColor.withOpacity(0.6),
                  fontWeight: AppTextStyles.fontWeightMedium,
                ),
              ),
              const Icon(Icons.bolt_rounded, size: 18, color: Colors.orange),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: AppColors.primary.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyProteinMiniChart extends ConsumerWidget {
  const _WeeklyProteinMiniChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyData = ref.watch(weeklyProteinIntakeProvider);
    final days = ["M", "T", "W", "T", "F", "S", "S"];
    final isDataEmpty = weeklyData.every((element) => element == 0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              "Weekly Trend",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: AppTextStyles.fontWeightBold,
                color: theme.hintColor.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (isDataEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: EmptyStatePlaceholder(
                  title: "No data yet",
                  description: "Protein intake trend will appear here",
                  icon: Icons.bar_chart_rounded,
                ),
              ),
            )
          else
            SizedBox(
              height: 130,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 200,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= days.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.hintColor.withOpacity(0.4),
                                fontSize: 11,
                                fontWeight: AppTextStyles.fontWeightBold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: weeklyData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: AppColors.primary.withOpacity(0.8),
                          width: 10,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 200,
                            color: AppColors.primary.withOpacity(0.03),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompactStreakAndGoalCard extends ConsumerWidget {
  const _CompactStreakAndGoalCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final streak = ref.watch(dashboardStreakProvider);
    final weeklyGoalProgress = ref.watch(weeklyGoalProgressProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildItem(
            context,
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            label: "Streak",
            value: "$streak Days",
          ),
          Container(
            height: 40,
            width: 1,
            color: theme.dividerColor.withOpacity(0.1),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          _buildItem(
            context,
            icon: Icons.ads_click_rounded,
            color: AppColors.primary,
            label: "Weekly Goal",
            value: "${(weeklyGoalProgress * 7).toInt()}/7 Days",
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.fontWeightBold,
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

class _RecentActivitySection extends ConsumerWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mealsAsync = ref.watch(mealProvider);
    final workoutsAsync = ref.watch(workoutsProvider);
    
    final meals = mealsAsync.value ?? [];
    final workouts = workoutsAsync.value ?? [];

    final activities = [
      ...meals.map((m) => _ActivityData(
            title: m.name,
            subtitle: "${m.protein.toInt()}g protein",
            time: m.createdAt,
            icon: Icons.restaurant_rounded,
            color: Colors.green,
          )),
      ...workouts.map((w) => _ActivityData(
            title: w.name,
            subtitle: "${w.durationMinutes}m • ${w.caloriesBurned}kcal",
            time: w.createdAt,
            icon: Icons.fitness_center_rounded,
            color: Colors.blue,
          )),
    ]..sort((a, b) => b.time.compareTo(a.time));

    final displayActivities = activities.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Activity",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.fontWeightBold,
                letterSpacing: -0.2,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "See all",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.fontWeightBold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (displayActivities.isEmpty)
          EmptyStateCard(
            title: "No recent activity",
            description: "Your logged meals and workouts will appear here",
            icon: Icons.history_rounded,
            actionLabel: "Add your first meal",
            onActionPressed: () => context.push("/add-meal"),
          )
        else
          ...displayActivities.map((activity) => _ActivityTile(activity: activity)),
      ],
    );
  }
}

class _ActivityData {
  final String title;
  final String subtitle;
  final DateTime time;
  final IconData icon;
  final Color color;

  _ActivityData({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class _ActivityTile extends StatelessWidget {
  final _ActivityData activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
            ),
            child: Icon(activity.icon, color: activity.color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.fontWeightSemiBold,
                  ),
                ),
                Text(
                  activity.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('h:mm a').format(activity.time),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
