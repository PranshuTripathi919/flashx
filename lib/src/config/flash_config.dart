import 'package:flutter/material.dart';
import '../../flashx.dart' show FlashX, FlashXWidget;
import '../enums/flash_enums.dart';
import '../themes/flash_theme_data.dart';

/// Global defaults applied to every [FlashX] notification unless overridden
/// at the call site.
///
/// Apply via [FlashX.configure]:
/// ```dart
/// FlashX.configure(
///   FlashXConfig(
///     position: FlashPosition.bottom,
///     animation: FlashAnimation.fade,
///     borderRadius: BorderRadius.circular(20),
///     blur: true,
///   ),
/// );
/// ```
class FlashXConfig {
  /// Default position for all notifications.
  final FlashPosition position;

  /// Default animation style.
  final FlashAnimation animation;

  /// Default auto-dismiss duration. Set to [Duration.zero] for persistent.
  final Duration duration;

  /// Default border radius. Applied to the notification card.
  final BorderRadius borderRadius;

  /// Whether to enable blur/glassmorphism by default.
  final bool blur;

  /// Default enter animation duration.
  final Duration animationDuration;

  /// Default exit animation duration.
  final Duration exitAnimationDuration;

  /// Default horizontal margin.
  final double marginHorizontal;

  /// Default vertical margin.
  final double marginVertical;

  /// Default max width. [null] = full width minus margins.
  final double? maxWidth;

  /// Maximum number of notifications visible simultaneously (stacked mode).
  final int maxVisible;

  /// Whether to enable stacked mode (multiple notifications visible at once).
  final bool stackedMode;

  /// Space between stacked notifications (stacked mode only).
  final double stackSpacing;

  /// Override default theme data for a given [FlashType].
  final Map<FlashType, FlashThemeData> typeThemeOverrides;

  /// Whether to show the progress bar by default.
  final bool showProgress;

  /// Default dismiss direction.
  final FlashDismissDirection dismissDirection;

  /// Optional global navigator key. Provide when you cannot use a
  /// [FlashXWidget] wrapper (e.g., in pure state-management-first apps).
  final GlobalKey<NavigatorState>? navigatorKey;

  const FlashXConfig({
    this.position = FlashPosition.top,
    this.animation = FlashAnimation.slide,
    this.duration = const Duration(seconds: 4),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blur = false,
    this.animationDuration = const Duration(milliseconds: 380),
    this.exitAnimationDuration = const Duration(milliseconds: 280),
    this.marginHorizontal = 12,
    this.marginVertical = 12,
    this.maxWidth,
    this.maxVisible = 3,
    this.stackedMode = false,
    this.stackSpacing = 8,
    this.typeThemeOverrides = const {},
    this.showProgress = true,
    this.dismissDirection = FlashDismissDirection.horizontal,
    this.navigatorKey,
  });

  FlashXConfig copyWith({
    FlashPosition? position,
    FlashAnimation? animation,
    Duration? duration,
    BorderRadius? borderRadius,
    bool? blur,
    Duration? animationDuration,
    Duration? exitAnimationDuration,
    double? marginHorizontal,
    double? marginVertical,
    double? maxWidth,
    int? maxVisible,
    bool? stackedMode,
    double? stackSpacing,
    Map<FlashType, FlashThemeData>? typeThemeOverrides,
    bool? showProgress,
    FlashDismissDirection? dismissDirection,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return FlashXConfig(
      position: position ?? this.position,
      animation: animation ?? this.animation,
      duration: duration ?? this.duration,
      borderRadius: borderRadius ?? this.borderRadius,
      blur: blur ?? this.blur,
      animationDuration: animationDuration ?? this.animationDuration,
      exitAnimationDuration:
          exitAnimationDuration ?? this.exitAnimationDuration,
      marginHorizontal: marginHorizontal ?? this.marginHorizontal,
      marginVertical: marginVertical ?? this.marginVertical,
      maxWidth: maxWidth ?? this.maxWidth,
      maxVisible: maxVisible ?? this.maxVisible,
      stackedMode: stackedMode ?? this.stackedMode,
      stackSpacing: stackSpacing ?? this.stackSpacing,
      typeThemeOverrides: typeThemeOverrides ?? this.typeThemeOverrides,
      showProgress: showProgress ?? this.showProgress,
      dismissDirection: dismissDirection ?? this.dismissDirection,
      navigatorKey: navigatorKey ?? this.navigatorKey,
    );
  }
}
