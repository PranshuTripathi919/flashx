import '../../flashx.dart' show FlashThemeData;
import '../themes/flash_theme_data.dart' show FlashThemeData;

/// Defines the visual type/style of the flash notification.
enum FlashType {
  /// Success — green palette
  success,

  /// Error — red palette
  error,

  /// Warning — amber/orange palette
  warning,

  /// Info — blue palette
  info,

  /// Loading — indigo with spinner
  loading,

  /// Custom — no preset styles; provide your own [FlashThemeData]
  custom,
}

/// Defines where the notification appears on the screen.
enum FlashPosition {
  /// Appears at the top of the screen (default)
  top,

  /// Appears at the bottom of the screen
  bottom,

  /// Centered horizontally and vertically (toast style)
  center,
}

/// Built-in animation presets.
enum FlashAnimation {
  /// Slides in from the edge nearest to [FlashPosition]
  slide,

  /// Fades in / out
  fade,

  /// Scales from center
  scale,

  /// Elastic spring entrance
  elastic,

  /// Bounce entrance
  bounce,

  /// Rotation + fade
  rotation,

  /// iOS-style ease-in-out
  ios,
}

/// Priority level for the queue system.
enum FlashPriority {
  /// Queued normally (FIFO order)
  normal,

  /// Jumps ahead of normal priority items
  high,

  /// Displayed immediately, regardless of queue
  critical,
}

/// Dismiss direction for swipe gestures.
enum FlashDismissDirection {
  /// Swipe up to dismiss
  up,

  /// Swipe down to dismiss
  down,

  /// Swipe left to dismiss
  left,

  /// Swipe right to dismiss
  right,

  /// Swipe up or down
  vertical,

  /// Swipe left or right
  horizontal,

  /// Any direction
  any,

  /// Disable swipe dismiss
  none,
}
