import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.acrylicBackgroundColor,
    required this.sidebarBackgroundColor,
    required this.playerControlHeight,
    required this.spacingScale,
    required this.cardBorderRadius,
  });

  final Color acrylicBackgroundColor;
  final Color sidebarBackgroundColor;
  final double playerControlHeight;
  final double spacingScale;
  final double cardBorderRadius;

  @override
  AppThemeExtension copyWith({
    Color? acrylicBackgroundColor,
    Color? sidebarBackgroundColor,
    double? playerControlHeight,
    double? spacingScale,
    double? cardBorderRadius,
  }) {
    return AppThemeExtension(
      acrylicBackgroundColor: acrylicBackgroundColor ?? this.acrylicBackgroundColor,
      sidebarBackgroundColor: sidebarBackgroundColor ?? this.sidebarBackgroundColor,
      playerControlHeight: playerControlHeight ?? this.playerControlHeight,
      spacingScale: spacingScale ?? this.spacingScale,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      acrylicBackgroundColor: Color.lerp(acrylicBackgroundColor, other.acrylicBackgroundColor, t)!,
      sidebarBackgroundColor: Color.lerp(sidebarBackgroundColor, other.sidebarBackgroundColor, t)!,
      playerControlHeight: Color.lerp(const Color(0x00000000), const Color(0x00000000), t) == null
          ? other.playerControlHeight
          : (playerControlHeight + (other.playerControlHeight - playerControlHeight) * t),
      spacingScale: spacingScale + (other.spacingScale - spacingScale) * t,
      cardBorderRadius: cardBorderRadius + (other.cardBorderRadius - cardBorderRadius) * t,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFF6750A4);

  // Dynamic light theme base configurations
  static ThemeData getLightTheme(ColorScheme? dynamicColorScheme) {
    final colorScheme = dynamicColorScheme ??
        ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      extensions: [
        AppThemeExtension(
          acrylicBackgroundColor: colorScheme.surfaceContainerLow,
          sidebarBackgroundColor: colorScheme.surfaceContainer,
          playerControlHeight: 88.0,
          spacingScale: 4.0,
          cardBorderRadius: 12.0,
        ),
      ],
    );
  }

  // Dynamic dark theme base configurations
  static ThemeData getDarkTheme(ColorScheme? dynamicColorScheme) {
    final colorScheme = dynamicColorScheme ??
        ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      extensions: const [
        AppThemeExtension(
          acrylicBackgroundColor: Color(0xCC0F1321), // Muted dark translucent
          sidebarBackgroundColor: Color(0xFF171B2A), // Dark sidebar base
          playerControlHeight: 96.0,
          spacingScale: 4.0,
          cardBorderRadius: 16.0,
        ),
      ],
    );
  }
}
