import 'package:fittrack/theme/app_colors.dart';
import 'package:fittrack/theme/app_radius.dart';
import 'package:fittrack/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final onPrimaryColor = Colors.white;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        gradient: isSecondary ? null : LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.8),
          ],
        ),
        boxShadow: isSecondary ? null : [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.transparent : Colors.transparent,
          foregroundColor: isSecondary 
            ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
            : onPrimaryColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            side: isSecondary 
              ? BorderSide(color: isDark ? AppColors.darkSurface : Colors.grey[300]!)
              : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSecondary ? primaryColor : onPrimaryColor,
                  ),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.bodyMd.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isSecondary 
                    ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                    : onPrimaryColor,
                ),
              ),
      ),
    );
  }
}
