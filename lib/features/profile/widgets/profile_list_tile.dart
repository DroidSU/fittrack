import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingValue;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool showDivider;
  final Widget? trailing;

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingValue,
    required this.onTap,
    this.iconColor,
    this.titleColor,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: AppTextStyles.fontWeightSemiBold,
                          color: titleColor ?? theme.colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingValue != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      trailingValue!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                trailing ?? Icon(
                  Icons.chevron_right_rounded,
                  color: theme.hintColor.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 60, right: AppSpacing.md),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.05),
            ),
          ),
      ],
    );
  }
}
