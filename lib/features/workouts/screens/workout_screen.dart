import 'package:fittrack/features/workouts/providers/workout_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_entry.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutState();
}

class _WorkoutState extends ConsumerState<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final workoutsAsync = ref.watch(workoutsProvider);
    final totalCalories = ref.watch(totalCaloriesProvider);
    final totalDuration = ref.watch(totalDurationProvider);
    final workoutsCompleted = ref.watch(workoutsCompletedProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: _AddWorkoutFAB(),
      body: SafeArea(
        child: workoutsAsync.when(
          data: (workouts) {
            final now = DateTime.now();
            final todayWorkouts = workouts.where((w) {
              return w.createdAt.year == now.year && 
                     w.createdAt.month == now.month && 
                     w.createdAt.day == now.day;
            }).toList().reversed.toList();

            final yesterdayWorkouts = workouts.where((w) {
              final yesterday = now.subtract(const Duration(days: 1));
              return w.createdAt.year == yesterday.year && 
                     w.createdAt.month == yesterday.month && 
                     w.createdAt.day == yesterday.day;
            }).toList().reversed.toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Workouts",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: AppTextStyles.fontWeightBold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "Track your workouts and stay consistent",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.calendar_today_outlined, 
                            color: theme.colorScheme.onSurface, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 2. Summary Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Summary",
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: AppTextStyles.fontWeightBold),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Text("View Weekly Stats",
                            style:
                                TextStyle(fontSize: AppTextStyles.fontSizeSm)),
                        label: const Icon(Icons.chevron_right, size: 18),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. Summary Card
                  _SummaryCard(
                    theme: theme, 
                    isDark: isDark,
                    completed: workoutsCompleted,
                    calories: totalCalories,
                    duration: totalDuration,
                  ),
                  const SizedBox(height: 20),

                  // 4. Workout History Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Workout History",
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: AppTextStyles.fontWeightBold),
                      ),
                      Row(
                        children: [
                          Text(
                            "Newest",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (workouts.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: AnimatedEntry(
                          child: Text(
                            "No workouts logged yet",
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else ...[
                    if (todayWorkouts.isNotEmpty) ...[
                      Text(
                        "TODAY",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...todayWorkouts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final workout = entry.value;
                        return _WorkoutHistoryItem(
                          index: index,
                          id: workout.id,
                          title: workout.name,
                          time: DateFormat('h:mm a').format(workout.createdAt),
                          duration: "${workout.durationMinutes} min",
                          calories: "${workout.caloriesBurned} kcal",
                          emoji: workout.type.emoji,
                          onDelete: () {
                            ref.read(workoutsProvider.notifier).removeWorkout(workout.id);
                          },
                        );
                      }),
                    ],
                    
                    if (yesterdayWorkouts.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        "YESTERDAY",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...yesterdayWorkouts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final workout = entry.value;
                        return _WorkoutHistoryItem(
                          index: index + todayWorkouts.length,
                          id: workout.id,
                          title: workout.name,
                          time: DateFormat('h:mm a').format(workout.createdAt),
                          duration: "${workout.durationMinutes} min",
                          calories: "${workout.caloriesBurned} kcal",
                          emoji: workout.type.emoji,
                          onDelete: () {
                            ref.read(workoutsProvider.notifier).removeWorkout(workout.id);
                          },
                        );
                      }),
                    ],
                  ],

                  const SizedBox(height: AppSpacing.lg),
                  // 6. Motivation Card
                  const _MotivationCard(),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final int completed;
  final int calories;
  final int duration;

  const _SummaryCard({
    required this.theme, 
    required this.isDark,
    required this.completed,
    required this.calories,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SummaryStat(
              icon: Icons.fitness_center,
              value: "$completed",
              label: "Workouts\nCompleted",
              color: Colors.blue,
            ),
            VerticalDivider(color: theme.dividerColor.withOpacity(0.1), thickness: 1, width: 16),
            _SummaryStat(
              icon: Icons.local_fire_department,
              value: "$calories",
              unit: "kcal",
              label: "Calories\nBurned",
              color: Colors.orange,
            ),
            VerticalDivider(color: theme.dividerColor.withOpacity(0.1), thickness: 1, width: 16),
            _SummaryStat(
              icon: Icons.access_time_filled,
              value: "$duration",
              unit: "min",
              label: "Total\nDuration",
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? unit;
  final String label;
  final Color color;

  const _SummaryStat({
    required this.icon,
    required this.value,
    this.unit,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: AppTextStyles.fontWeightBold),
              ),
              if (unit != null) ...[
                const SizedBox(width: 2),
                Text(
                  unit!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutHistoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String time;
  final String duration;
  final String calories;
  final String emoji;
  final VoidCallback onDelete;
  final int index;

  const _WorkoutHistoryItem({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    required this.calories,
    required this.emoji,
    required this.onDelete,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedEntry(
      delay: Duration(milliseconds: index * 50),
      child: Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(emoji,
                    style:
                        const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: AppTextStyles.fontWeightBold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 11, color: theme.hintColor.withOpacity(0.5)),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoTag(icon: Icons.access_time, label: duration),
                        const SizedBox(width: 12),
                        _InfoTag(
                            icon: Icons.local_fire_department, label: calories),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.green, size: 14),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline,
                        color: Colors.redAccent.withOpacity(0.6), size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: AppTextStyles.fontWeightMedium,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _MotivationCard extends StatelessWidget {
  const _MotivationCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events_outlined, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Keep it up! 💪",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.fontWeightBold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  "Consistency is the key to your fitness goals.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF2E7D32).withOpacity(0.7),
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

class _AddWorkoutFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedEntry(
      offset: const Offset(0, 0.5),
      child: FloatingActionButton.extended(
        onPressed: () => context.push('/add-workout'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Workout",
          style: TextStyle(
              fontWeight: AppTextStyles.fontWeightBold,
              letterSpacing: 0.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
