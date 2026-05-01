library flashx;

import 'flashx.dart' show FlashXWidget;
import 'src/config/flash_config.dart';
import 'src/controllers/flash_controller.dart';
import 'src/enums/flash_enums.dart';
import 'src/models/flash_options.dart';
import 'src/overlay/flash_widget.dart' show FlashXWidget;

export 'src/config/flash_config.dart';
export 'src/enums/flash_enums.dart';
export 'src/extensions/flash_extensions.dart';
export 'src/models/flash_options.dart';
export 'src/overlay/flash_widget.dart';
export 'src/themes/flash_theme_data.dart';

/// 🔥 FlashX — The most powerful Flutter notification package.
///
/// Zero boilerplate, works with every state manager, and looks stunning.
///
/// ## Quick Start
///
/// 1. Wrap your app:
/// ```dart
/// MaterialApp(
///   builder: FlashXWidget.init(),
///   home: HomeScreen(),
/// );
/// ```
///
/// 2. Show notifications from anywhere:
/// ```dart
/// FlashX.success("Profile saved!");
/// FlashX.error("Payment failed.");
/// FlashX.warning("Low battery.");
/// FlashX.info("New version available.");
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// FlashX.show(
///   FlashOptions(
///     title: "No Internet",
///     message: "Please check your connection.",
///     type: FlashType.error,
///     position: FlashPosition.top,
///     animation: FlashAnimation.elastic,
///     actionText: "Retry",
///     onAction: () => reconnect(),
///   ),
/// );
/// ```
///
/// ## Future Tracking
///
/// ```dart
/// FlashX.future(
///   future: uploadFile(),
///   loading: "Uploading file...",
///   success: "Upload complete!",
///   error: "Upload failed. Try again.",
/// );
/// ```
class FlashX {
  FlashX._();

  /// Internal controller. Do not access directly — use the static API.
  static final FlashController _controller = FlashController();

  /// Exposed for [FlashXWidget] internal use only.
  static FlashController get controller => _controller;

  // ─── Configuration ──────────────────────────────────────────────────────────

  /// Applies global defaults for all subsequent notifications.
  ///
  /// Call this early in your app (e.g. in `main()`):
  ///
  /// ```dart
  /// FlashX.configure(
  ///   FlashXConfig(
  ///     position: FlashPosition.bottom,
  ///     animation: FlashAnimation.bounce,
  ///     blur: true,
  ///   ),
  /// );
  /// ```
  static void configure(FlashXConfig config) {
    _controller.configure(config);
  }

  // ─── Convenience constructors ────────────────────────────────────────────────

  /// Shows a **success** notification.
  ///
  /// ```dart
  /// FlashX.success("Profile saved!");
  /// FlashX.success("Uploaded", title: "Done");
  /// ```
  static int success(
    String message, {
    String? title,
    FlashOptions? options,
  }) {
    return show(
      (options ?? const FlashOptions()).copyWith(
        type: FlashType.success,
        message: message,
        title: title,
      ),
    );
  }

  /// Shows an **error** notification.
  ///
  /// ```dart
  /// FlashX.error("Payment failed.");
  /// ```
  static int error(
    String message, {
    String? title,
    FlashOptions? options,
  }) {
    return show(
      (options ?? const FlashOptions()).copyWith(
        type: FlashType.error,
        message: message,
        title: title,
      ),
    );
  }

  /// Shows a **warning** notification.
  ///
  /// ```dart
  /// FlashX.warning("Weak signal detected.");
  /// ```
  static int warning(
    String message, {
    String? title,
    FlashOptions? options,
  }) {
    return show(
      (options ?? const FlashOptions()).copyWith(
        type: FlashType.warning,
        message: message,
        title: title,
      ),
    );
  }

  /// Shows an **info** notification.
  ///
  /// ```dart
  /// FlashX.info("Update v2.0 is available.");
  /// ```
  static int info(
    String message, {
    String? title,
    FlashOptions? options,
  }) {
    return show(
      (options ?? const FlashOptions()).copyWith(
        type: FlashType.info,
        message: message,
        title: title,
      ),
    );
  }

  /// Shows a **loading** notification (persistent until dismissed).
  ///
  /// Returns the ID so you can dismiss it later:
  ///
  /// ```dart
  /// final id = FlashX.loading("Uploading...");
  /// await upload();
  /// FlashX.dismissById(id);
  /// FlashX.success("Done!");
  /// ```
  static int loading(String message, {String? title}) {
    return show(
      FlashOptions(
        type: FlashType.loading,
        message: message,
        title: title,
        duration: null, // persistent
        showProgress: false,
        dismissDirection: FlashDismissDirection.none,
      ),
    );
  }

  /// Shows the notification described by [options] and returns its queue ID.
  ///
  /// ```dart
  /// FlashX.show(FlashOptions(
  ///   type: FlashType.success,
  ///   message: "All good!",
  ///   position: FlashPosition.bottom,
  ///   animation: FlashAnimation.slide,
  ///   actionText: "Undo",
  ///   onAction: () => undoLastAction(),
  /// ));
  /// ```
  static int show(FlashOptions options) {
    return _controller.enqueue(options);
  }

  // ─── Future API ─────────────────────────────────────────────────────────────

  /// Tracks a [Future] and shows loading → success/error notifications
  /// automatically.
  ///
  /// [success] and [error] can be either a [String] or a
  /// `String Function(T result)` / `String Function(Object error)`.
  ///
  /// ```dart
  /// await FlashX.future(
  ///   future: uploadData(),
  ///   loading: "Uploading...",
  ///   success: "Upload complete!",
  ///   error: "Upload failed.",
  /// );
  /// ```
  static Future<T> future<T>({
    required Future<T> future,
    String loading = 'Loading...',
    Object success = 'Done!',
    Object error = 'Something went wrong.',
    String? loadingTitle,
    String? successTitle,
    String? errorTitle,
    FlashOptions? loadingOptions,
    FlashOptions? successOptions,
    FlashOptions? errorOptions,
  }) async {
    final id = FlashX.loading(loading);
    try {
      final result = await future;
      await dismissById(id);
      final successMsg =
          success is String Function(T) ? success(result) : success.toString();
      FlashX.success(successMsg, title: successTitle, options: successOptions);
      return result;
    } catch (e) {
      await dismissById(id);
      final errorMsg =
          error is String Function(Object) ? error(e) : error.toString();
      FlashX.error(errorMsg, title: errorTitle, options: errorOptions);
      rethrow;
    }
  }

  // ─── Dismiss API ─────────────────────────────────────────────────────────────

  /// Dismisses all visible notifications and clears the queue.
  ///
  /// ```dart
  /// FlashX.dismissAll();
  /// ```
  static Future<void> dismissAll() => _controller.dismissAll();

  /// Dismisses a specific notification by its [id] (returned by [show]).
  ///
  /// ```dart
  /// final id = FlashX.loading("Working...");
  /// await doWork();
  /// FlashX.dismissById(id);
  /// ```
  static Future<void> dismissById(int id) => _controller.dismissById(id);
}
