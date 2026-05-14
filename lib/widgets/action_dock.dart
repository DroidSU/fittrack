import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ActionDock extends StatefulWidget {
  final VoidCallback onLogMeal;
  final VoidCallback onLogWorkout;

  const ActionDock({
    super.key,
    required this.onLogMeal,
    required this.onLogWorkout,
  });

  @override
  State<ActionDock> createState() => _ActionDockState();
}

class _ActionDockState extends State<ActionDock> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Backdrop Blur when expanded
        if (_isExpanded)
          GestureDetector(
            onTap: _toggle,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: 300.ms,
              builder: (context, value, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4 * value, sigmaY: 4 * value),
                  child: Container(
                    color: Colors.black.withOpacity(0.2 * value),
                  ),
                );
              },
            ),
          ).animate().fadeIn(),

        // The Morphing Dock
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: AnimatedContainer(
            duration: 400.ms,
            curve: Curves.easeOutBack,
            width: _isExpanded ? 300 : 160,
            height: _isExpanded ? 100 : 56,
            decoration: BoxDecoration(
              color: _isExpanded 
                  ? (theme.brightness == Brightness.dark ? AppColors.darkSurface : Colors.white)
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedContent() {
    return InkWell(
      onTap: _toggle,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_rounded, color: Colors.white, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Text(
            "Log Activity",
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: AppTextStyles.fontWeightBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Row(
      children: [
        _buildActionItem(
          icon: Icons.restaurant_rounded,
          label: "Meal",
          color: Colors.green,
          onTap: () {
            _toggle();
            widget.onLogMeal();
          },
        ),
        VerticalDivider(
          color: Colors.grey.withOpacity(0.1),
          indent: 20,
          endIndent: 20,
        ),
        _buildActionItem(
          icon: Icons.fitness_center_rounded,
          label: "Workout",
          color: Colors.blue,
          onTap: () {
            _toggle();
            widget.onLogWorkout();
          },
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                fontWeight: AppTextStyles.fontWeightBold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
