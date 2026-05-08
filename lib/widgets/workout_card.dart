import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_spacing.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard({super.key});

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color greenAccent = Color(0xFF34A853);
    final Color greenTheme = theme.brightness == Brightness.light
        ? const Color(0xFFF0F9F6)
        : greenAccent.withOpacity(0.1);

    return Hero(
      tag: 'workout-card-empty',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () => context.push('/add-workout'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: greenTheme,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: greenAccent.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fitness_center,
                            color: greenAccent, size: 16),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          "Workout",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: greenAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      "Not logged yet",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Track your workout and stay consistent!",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        height: 1.3,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: greenAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_run,
                    color: greenAccent, size: 28),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right,
                  color: theme.iconTheme.color?.withOpacity(0.4), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
