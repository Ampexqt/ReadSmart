import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Neobrutalism Design System for ReadSmart
class DesignSystem {
  // Current Font Family (set from main.dart)
  static String? currentFontFamily;

  // Light Mode Colors
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFE5E5E5);
  static const Color grey300 = Color(0xFFD4D4D4);
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey600 = Color(0xFF525252);
  static const Color grey700 = Color(0xFF404040);
  static const Color grey800 = Color(0xFF262626);
  static const Color grey900 = Color(0xFF171717);

  static const Color yellow100 = Color(0xFFFEF3C7);

  // Dark Mode Colors (Only 3 colors - easy on eyes)
  static const Color darkBackground = Color(0xFF1A1A1A); // Dark gray background
  static const Color darkCard = Color(0xFF2A2A2A); // Slightly lighter for cards
  static const Color darkText = Color(0xFFE5E5E5); // Soft white for text
  static const Color darkBorder = Color(0xFF404040); // Medium gray borders

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacing2XL = 48.0;
  static const double spacing3XL = 64.0;

  // Borders
  static const double borderWidth = 3.0;
  static const double borderWidthSmall = 2.0;
  static const BorderSide borderSide = BorderSide(
    color: primaryBlack,
    width: borderWidth,
  );
  static const BorderSide borderSideSmall = BorderSide(
    color: primaryBlack,
    width: borderWidthSmall,
  );
  static const Border border = Border.fromBorderSide(borderSide);
  static const Border borderSmall = Border.fromBorderSide(borderSideSmall);

  // Shadows (sharp offset, no blur)
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: primaryBlack,
      offset: const Offset(4, 4),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: primaryBlack,
      offset: const Offset(6, 6),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: primaryBlack,
      offset: const Offset(8, 8),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  // Typography
  static TextStyle textStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = primaryBlack,
    double letterSpacing = -0.02,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    // Use passed fontFamily, or fallback to global currentFontFamily
    final effectiveFontFamily = fontFamily ?? currentFontFamily;

    // If a specific font family is provided, use it
    if (effectiveFontFamily == 'Lora') {
      return GoogleFonts.lora(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
      );
    } else if (effectiveFontFamily == 'Merriweather') {
      return GoogleFonts.merriweather(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
      );
    } else if (effectiveFontFamily == 'Crimson Text') {
      return GoogleFonts.crimsonText(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
      );
    }

    // Default to Space Grotesk
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  // Text Styles
  static TextStyle get textXS => textStyle(fontSize: 12, letterSpacing: 0.05);
  static TextStyle get textSM => textStyle(fontSize: 14, letterSpacing: 0.02);
  static TextStyle get textBase => textStyle(fontSize: 16);
  static TextStyle get textLG => textStyle(fontSize: 18);
  static TextStyle get textXL => textStyle(fontSize: 20);
  static TextStyle get text2XL => textStyle(fontSize: 24);
  static TextStyle get text3XL => textStyle(fontSize: 30);
  static TextStyle get text4XL => textStyle(fontSize: 36);
  static TextStyle get text5XL => textStyle(fontSize: 48);

  static TextStyle get textBold => textStyle(fontWeight: FontWeight.w700);
  static TextStyle get textBlack => textStyle(fontWeight: FontWeight.w900);
  static TextStyle get textMedium => textStyle(fontWeight: FontWeight.w500);
  static TextStyle get textSemiBold => textStyle(fontWeight: FontWeight.w600);

  static TextStyle get labelStyle =>
      textXS.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.05);

  // Button Styles
  static TextStyle get buttonStyle =>
      textBase.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.05);

  // Container Constraints
  static const double maxWidth = 448.0;
  static const double bookCoverAspectRatio = 3 / 4;

  // Icon Sizes
  static const double iconSizeXS = 12.0;
  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 20.0;
  static const double iconSizeLG = 24.0;
  static const double iconSizeXL = 40.0;
  static const double iconSize2XL = 48.0;
  static const double iconSize3XL = 64.0;

  // Stroke Width
  static const double strokeWidth = 3.0;

  // Theme-aware color getters
  static Color backgroundColor(bool isDark) =>
      isDark ? darkBackground : primaryWhite;

  static Color cardColor(bool isDark) => isDark ? darkCard : primaryWhite;

  static Color textColor(bool isDark) => isDark ? darkText : primaryBlack;

  static Color borderColor(bool isDark) => isDark ? darkBorder : primaryBlack;

  static Color invertedColor(bool isDark) =>
      isDark ? primaryWhite : primaryBlack;

  static BorderSide themeBorderSide(bool isDark) =>
      BorderSide(color: borderColor(isDark), width: borderWidth);

  static Border themeBorder(bool isDark) =>
      Border.fromBorderSide(themeBorderSide(isDark));

  static List<BoxShadow> themeShadowSmall(bool isDark) => [
    BoxShadow(
      color: isDark ? darkBorder : primaryBlack,
      offset: const Offset(4, 4),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];
}
