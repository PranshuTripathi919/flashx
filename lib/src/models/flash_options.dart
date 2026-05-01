import 'package:flutter/material.dart';
import '../../flashx.dart' show FlashX;
import '../enums/flash_enums.dart';
import '../themes/flash_theme_data.dart';

/// The complete data model for a single FlashX notification.
///
/// Pass to [FlashX.show] for full control, or use the convenience methods
/// ([FlashX.success], [FlashX.error], etc.) for common scenarios.
class FlashOptions {
  // ─── Content ────────────────────────────────────────────────────────────────

  /// Optional bold title text.
  final String? title;

  /// Main message body. Required unless [customWidget] is provided.
  final String? message;

  /// Override the auto-selected icon with a specific [IconData].
  final IconData? icon;

  /// Hide the icon entirely.
  final bool showIcon;

  /// Optional fully custom widget to render inside the notification card.
  /// When provided, [title], [message], and [icon] are ignored.
  final Widget? customWidget;

  // ─── Type & Position ────────────────────────────────────────────────────────

  /// The visual type — controls colors and default icon.
  final FlashType type;

  /// Where on the screen the notification appears.
  final FlashPosition position;

  // ─── Animation ──────────────────────────────────────────────────────────────

  /// Built-in entrance/exit animation style.
  final FlashAnimation animation;

  /// Duration for the enter animation.
  final Duration animationDuration;

  /// Duration for the exit animation.
  final Duration exitAnimationDuration;

  /// Custom animation builder. If provided, [animation] is ignored.
  /// Receives the [AnimationController] and [child] widget.
  final Widget Function(AnimationController controller, Widget child)?
      animationBuilder;

  // ─── Timing ─────────────────────────────────────────────────────────────────

  /// How long the notification stays visible before auto-dismissing.
  /// Set to [Duration.zero] or [null] to make it persistent.
  final Duration? duration;

  // ─── Actions ────────────────────────────────────────────────────────────────

  /// Label for the optional action button.
  final String? actionText;

  /// Callback when the action button is tapped.
  final VoidCallback? onAction;

  /// Label for a second optional action button.
  final String? secondaryActionText;

  /// Callback for the secondary action button.
  final VoidCallback? onSecondaryAction;

  // ─── Interactions ───────────────────────────────────────────────────────────

  /// Dismiss direction(s) for swipe gestures.
  final FlashDismissDirection dismissDirection;

  /// Called when the notification is dismissed (any reason).
  final VoidCallback? onDismissed;

  /// Called when the user taps the notification body.
  final VoidCallback? onTap;

  // ─── Progress bar ────────────────────────────────────────────────────────────

  /// Whether to show the animated countdown progress bar.
  final bool showProgress;

  // ─── Appearance ─────────────────────────────────────────────────────────────

  /// Override the auto-detected theme data.
  final FlashThemeData? themeData;

  /// Maximum width of the notification card.
  final double? maxWidth;

  /// Horizontal margin from screen edges.
  final double marginHorizontal;

  /// Vertical margin from screen edges (top or bottom).
  final double marginVertical;

  /// Padding inside the notification card.
  final EdgeInsetsGeometry? padding;

  // ─── Queue & Priority ───────────────────────────────────────────────────────

  /// Priority in the queue.
  final FlashPriority priority;

  /// A unique key. If a notification with the same key is already showing
  /// or in the queue, the new one is dropped (duplicate prevention).
  final String? key;

  // ─── Accessibility ──────────────────────────────────────────────────────────

  /// Semantic label for screen readers. Defaults to "[type]: [message]".
  final String? semanticLabel;

  const FlashOptions({
    this.title,
    this.message,
    this.icon,
    this.showIcon = true,
    this.customWidget,
    this.type = FlashType.info,
    this.position = FlashPosition.top,
    this.animation = FlashAnimation.slide,
    this.animationDuration = const Duration(milliseconds: 380),
    this.exitAnimationDuration = const Duration(milliseconds: 280),
    this.animationBuilder,
    this.duration = const Duration(seconds: 4),
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.dismissDirection = FlashDismissDirection.horizontal,
    this.onDismissed,
    this.onTap,
    this.showProgress = true,
    this.themeData,
    this.maxWidth,
    this.marginHorizontal = 12,
    this.marginVertical = 12,
    this.padding,
    this.priority = FlashPriority.normal,
    this.key,
    this.semanticLabel,
  });

  /// Creates a copy of this [FlashOptions] with the given fields overridden.
  FlashOptions copyWith({
    String? title,
    String? message,
    IconData? icon,
    bool? showIcon,
    Widget? customWidget,
    FlashType? type,
    FlashPosition? position,
    FlashAnimation? animation,
    Duration? animationDuration,
    Duration? exitAnimationDuration,
    Widget Function(AnimationController, Widget)? animationBuilder,
    Duration? duration,
    String? actionText,
    VoidCallback? onAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    FlashDismissDirection? dismissDirection,
    VoidCallback? onDismissed,
    VoidCallback? onTap,
    bool? showProgress,
    FlashThemeData? themeData,
    double? maxWidth,
    double? marginHorizontal,
    double? marginVertical,
    EdgeInsetsGeometry? padding,
    FlashPriority? priority,
    String? key,
    String? semanticLabel,
  }) {
    return FlashOptions(
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      showIcon: showIcon ?? this.showIcon,
      customWidget: customWidget ?? this.customWidget,
      type: type ?? this.type,
      position: position ?? this.position,
      animation: animation ?? this.animation,
      animationDuration: animationDuration ?? this.animationDuration,
      exitAnimationDuration:
          exitAnimationDuration ?? this.exitAnimationDuration,
      animationBuilder: animationBuilder ?? this.animationBuilder,
      duration: duration ?? this.duration,
      actionText: actionText ?? this.actionText,
      onAction: onAction ?? this.onAction,
      secondaryActionText: secondaryActionText ?? this.secondaryActionText,
      onSecondaryAction: onSecondaryAction ?? this.onSecondaryAction,
      dismissDirection: dismissDirection ?? this.dismissDirection,
      onDismissed: onDismissed ?? this.onDismissed,
      onTap: onTap ?? this.onTap,
      showProgress: showProgress ?? this.showProgress,
      themeData: themeData ?? this.themeData,
      maxWidth: maxWidth ?? this.maxWidth,
      marginHorizontal: marginHorizontal ?? this.marginHorizontal,
      marginVertical: marginVertical ?? this.marginVertical,
      padding: padding ?? this.padding,
      priority: priority ?? this.priority,
      key: key ?? this.key,
      semanticLabel: semanticLabel ?? this.semanticLabel,
    );
  }
}
