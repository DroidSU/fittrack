import 'package:flutter/material.dart';

import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class AchievementStrip extends StatelessWidget {
  final int streakDays;
  final int workoutCount;
  final int mealsLogged;

  const AchievementStrip({
    super.key,
    required this.streakDays,
    required this.workoutCount,
    required this.mealsLogged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildAchievementItem(
              context,
              icon: "🔥",
              value: "$streakDays",
              label: "Day Streak",
              iconBgColor: Colors.orange.withOpacity(0.1),
            ),
            _buildDivider(theme),
            _buildAchievementItem(
              context,
              icon: "🏋",
              value: "$workoutCount",
              label: "Workouts",
              iconBgColor: Colors.blue.withOpacity(0.1),
            ),
            _buildDivider(theme),
            _buildAchievementItem(
              context,
              icon: "🥗",
              value: "$mealsLogged",
              label: "Meals Logged",
              iconBgColor: Colors.green.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
    required Color iconBgColor,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.fontWeightBold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.hintColor.withOpacity(0.5),
              fontWeight: AppTextStyles.fontWeightMedium,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return VerticalDivider(
      color: theme.dividerColor.withOpacity(0.1),
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }
}
