import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color greenTheme = Color(0xFFF0F9F6);
    const Color greenAccent = Color(0xFF34A853);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: greenTheme,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fitness_center, color: greenAccent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Workout",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: greenAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Not logged yet",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Track your workout and stay consistent!",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: greenAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_run, color: greenAccent, size: 36),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        ],
      ),
    );
  }
}
