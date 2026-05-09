import 'package:flutter/material.dart';

class AppTextStyles {
  // Font Sizes
  static const double fontSizeXxs = 10.0;
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSizeXxl = 24.0;
  static const double fontSizeXxxl = 32.0;
  static const double fontSizeDisplay = 40.0;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontSize: fontSizeXxl,
    fontWeight: fontWeightBold,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: fontWeightBold,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightSemiBold,
  );

  // Body Styles
  static const TextStyle bodyLg = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: fontWeightNormal,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightNormal,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: fontWeightNormal,
  );

  // Small / Label Styles
  static const TextStyle label = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: fontWeightSemiBold,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSizeXxs,
    fontWeight: fontWeightNormal,
  );
}
