import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingNumberPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int selectedValue;
  final ValueChanged<int> onSelectedItemChanged;
  final String unit;

  const OnboardingNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.selectedValue,
    required this.onSelectedItemChanged,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: 60,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(
              initialItem: selectedValue - minValue,
            ),
            onSelectedItemChanged: (index) {
              onSelectedItemChanged(minValue + index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: maxValue - minValue + 1,
              builder: (context, index) {
                final value = minValue + index;
                final isSelected = value == selectedValue;
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value.toString(),
                        style: AppTextStyles.h1.copyWith(
                          fontSize: isSelected ? 32 : 24,
                          color: isSelected
                              ? primaryColor
                              : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          unit,
                          style: AppTextStyles.bodyLg.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
