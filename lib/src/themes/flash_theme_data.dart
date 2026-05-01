import 'package:flutter/material.dart';
import '../../flashx.dart' show FlashX;
import '../enums/flash_enums.dart';

/// Defines the visual appearance of a [FlashX] notification.
///
/// Use [FlashThemeData.forType] to get the built-in preset for a [FlashType],
/// or construct your own for fully custom styling.
class FlashThemeData {
  /// Background color of the notification card.
  final Color backgroundColor;

  /// Text color for the title and message.
  final Color textColor;

  /// Color of the icon.
  final Color iconColor;

  /// Color of the action button text.
  final Color actionColor;

  /// Color of the animated progress bar.
  final Color progressColor;

  /// Border color (set to transparent to disable border).
  final Color borderColor;

  /// Width of the border.
  final double borderWidth;

  /// Border radius for the notification card.
  final BorderRadius? borderRadius;

  /// Optional gradient — overrides [backgroundColor] if set.
  final Gradient? gradient;

  /// Shadow elevation.
  final double elevation;

  /// Shadow color.
  final Color shadowColor;

  /// If true, renders a blur/glassmorphism overlay instead of a solid card.
  final bool glassmorphism;

  /// Blur sigma when [glassmorphism] is true.
  final double blurSigma;

  /// Optional opacity when [glassmorphism] is true.
  final double glassOpacity;

  const FlashThemeData({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.actionColor,
    required this.progressColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderRadius,
    this.gradient,
    this.elevation = 8,
    this.shadowColor = const Color(0x40000000),
    this.glassmorphism = false,
    this.blurSigma = 10,
    this.glassOpacity = 0.15,
  });

  // ─── Built-in light presets ─────────────────────────────────────────────────

  static const FlashThemeData _successLight = FlashThemeData(
    backgroundColor: Color(0xFFF0FDF4),
    textColor: Color(0xFF14532D),
    iconColor: Color(0xFF16A34A),
    actionColor: Color(0xFF15803D),
    progressColor: Color(0xFF22C55E),
    borderColor: Color(0xFFBBF7D0),
    borderWidth: 1,
  );

  static const FlashThemeData _errorLight = FlashThemeData(
    backgroundColor: Color(0xFFFFF1F2),
    textColor: Color(0xFF4C0519),
    iconColor: Color(0xFFE11D48),
    actionColor: Color(0xFFBE123C),
    progressColor: Color(0xFFF43F5E),
    borderColor: Color(0xFFFFCDD5),
    borderWidth: 1,
  );

  static const FlashThemeData _warningLight = FlashThemeData(
    backgroundColor: Color(0xFFFFFBEB),
    textColor: Color(0xFF451A03),
    iconColor: Color(0xFFF59E0B),
    actionColor: Color(0xFFD97706),
    progressColor: Color(0xFFFBBF24),
    borderColor: Color(0xFFFDE68A),
    borderWidth: 1,
  );

  static const FlashThemeData _infoLight = FlashThemeData(
    backgroundColor: Color(0xFFEFF6FF),
    textColor: Color(0xFF1E3A5F),
    iconColor: Color(0xFF3B82F6),
    actionColor: Color(0xFF2563EB),
    progressColor: Color(0xFF60A5FA),
    borderColor: Color(0xFFBFDBFE),
    borderWidth: 1,
  );

  static const FlashThemeData _loadingLight = FlashThemeData(
    backgroundColor: Color(0xFFF5F3FF),
    textColor: Color(0xFF2E1065),
    iconColor: Color(0xFF7C3AED),
    actionColor: Color(0xFF6D28D9),
    progressColor: Color(0xFF8B5CF6),
    borderColor: Color(0xFFDDD6FE),
    borderWidth: 1,
  );

  // ─── Built-in dark presets ───────────────────────────────────────────────────

  static const FlashThemeData _successDark = FlashThemeData(
    backgroundColor: Color(0xFF052E16),
    textColor: Color(0xFFDCFCE7),
    iconColor: Color(0xFF4ADE80),
    actionColor: Color(0xFF86EFAC),
    progressColor: Color(0xFF22C55E),
    borderColor: Color(0xFF14532D),
    borderWidth: 1,
  );

  static const FlashThemeData _errorDark = FlashThemeData(
    backgroundColor: Color(0xFF4C0519),
    textColor: Color(0xFFFFE4E6),
    iconColor: Color(0xFFFB7185),
    actionColor: Color(0xFFFDA4AF),
    progressColor: Color(0xFFF43F5E),
    borderColor: Color(0xFF881337),
    borderWidth: 1,
  );

  static const FlashThemeData _warningDark = FlashThemeData(
    backgroundColor: Color(0xFF451A03),
    textColor: Color(0xFFFEF3C7),
    iconColor: Color(0xFFFCD34D),
    actionColor: Color(0xFFFDE68A),
    progressColor: Color(0xFFFBBF24),
    borderColor: Color(0xFF78350F),
    borderWidth: 1,
  );

  static const FlashThemeData _infoDark = FlashThemeData(
    backgroundColor: Color(0xFF0F2A4A),
    textColor: Color(0xFFDBEAFE),
    iconColor: Color(0xFF93C5FD),
    actionColor: Color(0xFFBFDBFE),
    progressColor: Color(0xFF60A5FA),
    borderColor: Color(0xFF1E3A5F),
    borderWidth: 1,
  );

  static const FlashThemeData _loadingDark = FlashThemeData(
    backgroundColor: Color(0xFF1E0A40),
    textColor: Color(0xFFEDE9FE),
    iconColor: Color(0xFFA78BFA),
    actionColor: Color(0xFFC4B5FD),
    progressColor: Color(0xFF8B5CF6),
    borderColor: Color(0xFF2E1065),
    borderWidth: 1,
  );

  // ─── Glassmorphism presets ──────────────────────────────────────────────────

  static FlashThemeData glassSuccess({bool dark = false}) => FlashThemeData(
        backgroundColor:
            dark ? const Color(0x3316A34A) : const Color(0x4422C55E),
        textColor: dark ? const Color(0xFFDCFCE7) : const Color(0xFF14532D),
        iconColor: dark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
        actionColor: dark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
        progressColor: const Color(0xFF22C55E),
        borderColor: dark ? const Color(0x6622C55E) : const Color(0x8022C55E),
        borderWidth: 1,
        glassmorphism: true,
        blurSigma: 12,
        glassOpacity: 0.2,
      );

  // ─── Factory ────────────────────────────────────────────────────────────────

  /// Returns the built-in [FlashThemeData] for [type] and [brightness].
  static FlashThemeData forType(FlashType type, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    switch (type) {
      case FlashType.success:
        return dark ? _successDark : _successLight;
      case FlashType.error:
        return dark ? _errorDark : _errorLight;
      case FlashType.warning:
        return dark ? _warningDark : _warningLight;
      case FlashType.info:
        return dark ? _infoDark : _infoLight;
      case FlashType.loading:
        return dark ? _loadingDark : _loadingLight;
      case FlashType.custom:
        return dark ? _infoDark : _infoLight;
    }
  }

  /// Creates a copy of this theme with the given fields overridden.
  FlashThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    Color? progressColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    Gradient? gradient,
    double? elevation,
    Color? shadowColor,
    bool? glassmorphism,
    double? blurSigma,
    double? glassOpacity,
  }) {
    return FlashThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      actionColor: actionColor ?? this.actionColor,
      progressColor: progressColor ?? this.progressColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      gradient: gradient ?? this.gradient,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      glassmorphism: glassmorphism ?? this.glassmorphism,
      blurSigma: blurSigma ?? this.blurSigma,
      glassOpacity: glassOpacity ?? this.glassOpacity,
    );
  }
}
