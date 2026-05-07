import 'package:fittrack/features/workouts/models/workout_emoji.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProteinCard extends StatelessWidget {
  final double current;
  final double target;
  final double percentage;

  const ProteinCard({
    super.key,
    required this.current,
    required this.target,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors that preserve the original look
    final Color cardBg = isDark ? theme.colorScheme.surface : const Color(0xFFF9F9FF);
    final Color badgeBg = isDark ? theme.colorScheme.surfaceVariant : Colors.white;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.wine_bar, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Today's Protein",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Text(
                  "Daily Goal: ${target.toInt()}g",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? theme.textTheme.bodySmall?.color : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // 2. Middle Section with Large Text and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "${current.toInt()}g",
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 48, // Restored exact dimension
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "/ ${target.toInt()}g",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                height: 80, // Restored exact dimension
                width: 80,  // Restored exact dimension
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  WorkoutEmoji.bodybuilding.value, 
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 3. Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 4. Percentage Footer
          Text(
            "${(percentage * 100).toInt()}% of your daily goal",
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? theme.textTheme.bodySmall?.color?.withOpacity(0.6) : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
