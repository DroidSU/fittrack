import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../features/analytics/providers/dashboard_analytics_provider.dart';
import '../features/meals/providers/meal_notifier.dart';
import '../features/workouts/providers/workout_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/animated_entry.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalProtein = ref.watch(totalProteinProvider);
    const targetProtein = 150.0;
    final proteinPercentage = (totalProtein / targetProtein).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DashboardHeader(),
              const SizedBox(height: AppSpacing.lg),
              _ProteinGoalCard(
                current: totalProtein,
                target: targetProtein,
                percentage: proteinPercentage,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: AppSpacing.lg),
              const _WeeklyIntakeChart().animate().fadeIn(delay: 100.ms),
              const SizedBox(height: AppSpacing.lg),
              const _StreakAndGoalSection().animate().fadeIn(delay: 200.ms),
              const SizedBox(height: AppSpacing.lg),
              const _InsightsSection().animate().fadeIn(delay: 300.ms),
              const SizedBox(height: AppSpacing.lg),
              const _RecentActivityTimeline().animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 100), // FAB spacing
            ],
          ),
        ),
      ),
      floatingActionButton: _PremiumFAB(
        onPressed: () => context.push("/add-meal"),
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning, Sujoy",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                fontWeight: AppTextStyles.fontWeightMedium,
              ),
            ),
            Text(
              "Dashboard",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: AppTextStyles.fontWeightBold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.insights_rounded, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _ProteinGoalCard extends StatelessWidget {
  final double current;
  final double target;
  final double percentage;

  const _ProteinGoalCard({
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
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 90,
                width: 90,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 10,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${current.toInt()}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: AppTextStyles.fontWeightBold,
                    ),
                  ),
                  Text(
                    "/${target.toInt()}g",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.hintColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Protein Goal",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.fontWeightBold,
                  ),
                ),
                Text(
                  "${(percentage * 100).toInt()}% completed",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.fontWeightSemiBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "${(target - current).clamp(0, target).toInt()}g remaining",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 6,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
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

class _WeeklyIntakeChart extends ConsumerWidget {
  const _WeeklyIntakeChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyData = ref.watch(weeklyProteinIntakeProvider);
    final avgProtein = ref.watch(averageProteinProvider);
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weekly Protein Intake",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: AppTextStyles.fontWeightBold,
                    ),
                  ),
                  Text(
                    "Daily average: ${avgProtein.toInt()}g",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.hintColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View Details",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.fontWeightBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 180,
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
                              color: theme.hintColor.withValues(alpha: 0.5),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.dividerColor.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeklyData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: AppColors.primary,
                        width: 12,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 200,
                          color: AppColors.primary.withValues(alpha: 0.05),
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

class _StreakAndGoalSection extends ConsumerWidget {
  const _StreakAndGoalSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final streak = ref.watch(dashboardStreakProvider);
    final weeklyGoalProgress = ref.watch(weeklyGoalProgressProvider);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.1),
                  Colors.orange.withValues(alpha: 0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        color: Colors.orange, size: 24),
                    Text(
                      "$streak",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: AppTextStyles.fontWeightBold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Day Streak",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.fontWeightBold,
                  ),
                ),
                Text(
                  "Keep it going!",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            value: weeklyGoalProgress,
                            strokeWidth: 3,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                        const Icon(Icons.check,
                            size: 12, color: AppColors.primary),
                      ],
                    ),
                    Text(
                      "${(weeklyGoalProgress * 7).toInt()}/7",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.fontWeightBold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Weekly Goal",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.fontWeightBold,
                  ),
                ),
                Text(
                  "Almost there",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightsSection extends ConsumerWidget {
  const _InsightsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final insights = ref.watch(dashboardInsightsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Insights",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppTextStyles.fontWeightBold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: insights.map((insight) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border:
                      Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(insight.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      insight.title,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor.withValues(alpha: 0.5),
                        fontWeight: AppTextStyles.fontWeightMedium,
                      ),
                    ),
                    Text(
                      insight.value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.fontWeightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      insight.subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RecentActivityTimeline extends ConsumerWidget {
  const _RecentActivityTimeline();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final meals = ref.watch(mealProvider);
    final workouts = ref.watch(workoutsProvider);

    final activities = [
      ...meals.map((m) => _ActivityItem(
          title: "Added ${m.name}",
          subtitle: "${m.protein.toInt()}g protein",
          time: m.createdAt,
          icon: Icons.restaurant_rounded,
          color: Colors.green)),
      ...workouts.map((w) => _ActivityItem(
          title: w.name,
          subtitle: "${w.durationMinutes} min • ${w.caloriesBurned} kcal",
          time: w.createdAt,
          icon: Icons.fitness_center_rounded,
          color: Colors.blue)),
    ]..sort((a, b) => b.time.compareTo(a.time));

    final latestActivities = activities.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Activity",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppTextStyles.fontWeightBold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (latestActivities.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Text(
                "No recent activity",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: latestActivities.length,
            itemBuilder: (context, index) {
              final activity = latestActivities[index];
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: activity.color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: activity.color, width: 2),
                          ),
                        ),
                        if (index != latestActivities.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: theme.dividerColor.withValues(alpha: 0.1),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  activity.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: AppTextStyles.fontWeightSemiBold,
                                  ),
                                ),
                                Text(
                                  DateFormat('h:mm a').format(activity.time),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.hintColor.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              activity.subtitle,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.hintColor.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ActivityItem {
  final String title;
  final String subtitle;
  final DateTime time;
  final IconData icon;
  final Color color;

  _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class _PremiumFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _PremiumFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedEntry(
      offset: const Offset(0, 0.5),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        elevation: 8,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  "Log Activity",
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontWeight: AppTextStyles.fontWeightBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
