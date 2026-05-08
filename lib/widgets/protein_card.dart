import 'package:fittrack/features/workouts/models/workout_emoji.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ProteinCard extends StatefulWidget {
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
  State<ProteinCard> createState() => _ProteinCardState();
}

class _ProteinCardState extends State<ProteinCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors that preserve the original look
    final Color cardBg = isDark ? theme.colorScheme.surface : const Color(0xFFF9F9FF);
    final Color badgeBg = isDark ? theme.colorScheme.surfaceVariant : Colors.white;
    
    return Hero(
      tag: 'protein-card',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(_isPressed ? 0.08 : 0.03),
                blurRadius: _isPressed ? 20 : 15,
                offset: Offset(0, _isPressed ? 12 : 8),
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
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.wine_bar, color: Colors.white, size: 12),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        "Today's Protein",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Text(
                      "Goal: ${widget.target.toInt()}g",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark ? theme.textTheme.bodySmall?.color : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              
              // 2. Middle Section with Large Text and Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Text(
                          "${widget.current.toInt()}g",
                          key: ValueKey<int>(widget.current.toInt()),
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 40, 
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "/ ${widget.target.toInt()}g",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 60, 
                    width: 60,  
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      WorkoutEmoji.bodybuilding.value, 
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 3. Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: widget.percentage),
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: AppSpacing.sm,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              // 4. Percentage Footer
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: widget.percentage),
                builder: (context, value, _) {
                  return Text(
                    "${(value * 100).toInt()}% of daily goal",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? theme.textTheme.bodySmall?.color?.withOpacity(0.6) : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
