import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/animated_entry.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String name;
  final String time;
  final String protein;
  final String image;
  final VoidCallback? onDelete;
  final int index;

  const MealItem({
    super.key,
    required this.id,
    required this.name,
    required this.time,
    required this.protein,
    required this.image,
    this.onDelete,
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
        onDismissed: (_) => onDelete?.call(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Meal Image / Emoji
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(image,
                    style:
                        const TextStyle(fontSize: AppTextStyles.fontSizeXl)),
              ),
              const SizedBox(width: 12),

              // 2. Name and Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: AppTextStyles.fontWeightBold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 12,
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.5)),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.5),
                            fontWeight: AppTextStyles.fontWeightMedium,
                            fontSize: AppTextStyles.fontSizeXxs,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Protein Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    protein,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: AppTextStyles.fontWeightBold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    "protein",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                      fontSize: AppTextStyles.fontSizeXxs,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),

              // 4. Delete Action
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
