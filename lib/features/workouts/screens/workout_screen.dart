import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: _AddWorkoutFAB(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Workouts",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "Track your workouts and stay consistent",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_today_outlined, 
                        color: theme.colorScheme.onSurface, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Summary Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Summary",
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Text("View Weekly Stats", style: TextStyle(fontSize: 12)),
                    label: const Icon(Icons.chevron_right, size: 14),
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
              _SummaryCard(theme: theme, isDark: isDark),
              const SizedBox(height: 20),

              // 4. Workout History Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Workout History",
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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

              // 5. Workout Cards - Today
              Text(
                "TODAY",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const _WorkoutHistoryItem(
                title: "Upper Body Strength",
                time: "09:30 AM",
                duration: "30 min",
                calories: "220 kcal",
                icon: Icons.fitness_center,
                iconColor: Colors.blue,
              ),
              const _WorkoutHistoryItem(
                title: "HIIT Cardio",
                time: "12:15 PM",
                duration: "25 min",
                calories: "200 kcal",
                icon: Icons.bolt,
                iconColor: Colors.orange,
              ),
              const _WorkoutHistoryItem(
                title: "Leg Day",
                time: "05:45 PM",
                duration: "40 min",
                calories: "200 kcal",
                icon: Icons.downhill_skiing, // Representative of legs
                iconColor: Colors.purple,
              ),

              const SizedBox(height: 16),
              // 5. Workout Cards - Yesterday
              Text(
                "YESTERDAY",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const _WorkoutHistoryItem(
                title: "Yoga Flow",
                time: "07:00 AM",
                duration: "30 min",
                calories: "150 kcal",
                icon: Icons.self_improvement,
                iconColor: Colors.teal,
              ),
              const _WorkoutHistoryItem(
                title: "Cycling",
                time: "06:30 PM",
                duration: "45 min",
                calories: "180 kcal",
                icon: Icons.directions_bike,
                iconColor: Colors.redAccent,
              ),

              const SizedBox(height: 24),
              // 6. Motivation Card
              const _MotivationCard(),
              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const _SummaryCard({required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            const _SummaryStat(
              icon: Icons.fitness_center,
              value: "3",
              label: "Workouts\nCompleted",
              color: Colors.blue,
            ),
            VerticalDivider(color: theme.dividerColor.withOpacity(0.1), thickness: 1, width: 16),
            const _SummaryStat(
              icon: Icons.local_fire_department,
              value: "620",
              unit: "kcal",
              label: "Calories\nBurned",
              color: Colors.orange,
            ),
            VerticalDivider(color: theme.dividerColor.withOpacity(0.1), thickness: 1, width: 16),
            const _SummaryStat(
              icon: Icons.access_time_filled,
              value: "95",
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
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (unit != null) ...[
                const SizedBox(width: 2),
                Text(
                  unit!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
              fontSize: 10,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutHistoryItem extends StatelessWidget {
  final String title;
  final String time;
  final String duration;
  final String calories;
  final IconData icon;
  final Color iconColor;

  const _WorkoutHistoryItem({
    required this.title,
    required this.time,
    required this.duration,
    required this.calories,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 9, color: theme.hintColor.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _InfoTag(icon: Icons.access_time, label: duration),
                    const SizedBox(width: 10),
                    _InfoTag(icon: Icons.local_fire_department, label: calories),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 10),
              ),
              const SizedBox(height: 6),
              Icon(Icons.more_vert, color: theme.hintColor.withOpacity(0.3), size: 18),
            ],
          ),
        ],
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
        Icon(icon, size: 12, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.emoji_events_outlined, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Keep it up! 💪",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Consistency is the key to your fitness goals.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF2E7D32).withOpacity(0.7),
                    fontSize: 12,
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
    return FloatingActionButton.extended(
      onPressed: () => context.push('/add-workout'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add),
      label: const Text(
        "Add Workout",
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
