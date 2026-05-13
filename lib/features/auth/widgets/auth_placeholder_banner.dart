import 'package:fittrack/features/auth/widgets/wave_clipper.dart';
import 'package:fittrack/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthPlaceholderBanner extends StatelessWidget {
  final IconData icon;
  final String? imagePath;
  final double? height;

  const AuthPlaceholderBanner({
    super.key,
    required this.icon,
    this.imagePath,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    
    // Default to a reasonable portion of the screen if height is not provided
    final bannerHeight = height ?? MediaQuery.of(context).size.height * 0.4;

    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: bannerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
        ),
        child: Stack(
          children: [
            // Abstract Shapes
            Positioned(
              top: -20,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withOpacity(0.15),
                      primaryColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            
            // Background Illustration Placeholder or Icon
            Center(
              child: imagePath != null
                  ? Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        imagePath!,
                        fit: BoxFit.contain,
                        height: bannerHeight * 0.6,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: bannerHeight * 0.25 > 56 ? 56 : bannerHeight * 0.25,
                        color: primaryColor,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
