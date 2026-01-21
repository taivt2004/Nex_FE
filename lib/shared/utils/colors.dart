import 'dart:math';

import 'package:flutter/material.dart';

class AppColor {
  static const primary = Color(0xFF006BB3);
  static const blueLightest = Color(0xFFD7F4FE);
  static const blueLighter = Color(0xFFAAD9E9);
  static const blue = Color(0xFF62B8F6);
  static const blueDark = Color(0xFF3C99DD);
  static const blueDarker = Color(0xFF2C79C1);
  static const blueDarkest = Color(0xFF1B2541);
  static const white = Color(0xFFFFFFFF);

  static const pink = Color(0xFFFEE3D7);
  static const brownLight = Color(0xFFE9C8AA);
  static const orange = Color(0xFFF69762);
  static const orangeDark = Color(0xFFDD893C);
  static const orangeDarkest = Color(0xFFC1502C);

  // Onboarding Colors
  static const onboardingGradientStart = Color(0xFF430B5D);
  static const onboardingGradientEnd = Color(0xFF030518);
  static const onboardingPrimaryButtonStart = Color(0xFF9D50FF);
  static const onboardingPrimaryButtonEnd = Color(0xFF6B24D9);
  static const onboardingSecondaryButtonBg = Color(0xFF1E1E2C);
  static const onboardingIndicatorActive = Color(0xFF8A2BE2);
  static const onboardingIndicatorInactive = Color(0xFF3E3E3E);
  static const onboardingTermsText = Color(0xFFB1B1B1);

  static const blueBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blue, blueDarker],
    stops: [
      0,
      0.7,
    ],
  );

  static String generateStringColor(String input) {
    return colorToString(generateColorFromString(input));
  }

  static Color generateColorFromString(String input) {
    // Generate a hash code from the input string (e.g., username)
    final hash = input.hashCode;

    // Add randomness to the color generation to increase diversity
    final random = Random(hash);

    // Extract RGB values from the hash by bit manipulation
    var red = (hash >> 16) & 0xFF; // Extract the red channel from the hash
    var green = (hash >> 8) & 0xFF; // Extract the green channel
    var blue = hash & 0xFF; // Extract the blue channel

    // Add some variability to avoid dull, grayish colors
    red = (red + random.nextInt(50)) % 256;
    green = (green + random.nextInt(50)) % 256;
    blue = (blue + random.nextInt(50)) % 256;

    // Ensure that the color isn't too dark by increasing brightness slightly
    red = min(255, red + 50);
    green = min(255, green + 50);
    blue = min(255, blue + 50);

    // Optionally, tweak to avoid too bright colors (if desired)
    red = red > 230 ? red - 40 : red;
    green = green > 230 ? green - 40 : green;
    blue = blue > 230 ? blue - 40 : blue;

    // Return a Color object using the adjusted RGB values
    return Color.fromARGB(255, red, green, blue);
  }

  /// Converts a Color to a string (hexadecimal format)
  static String colorToString(Color color) {
    // Convert the color to a hex string in ARGB format
    return color.toARGB32().toRadixString(16).padLeft(8, '0');
  }

  /// Converts a string (hexadecimal) back to a Color
  static Color stringToColor(String colorStr) {
    // Parse the string and convert it to an integer
    final colorInt = int.parse(colorStr, radix: 16);

    // Return the Color object using the integer value
    return Color(colorInt);
  }
}
