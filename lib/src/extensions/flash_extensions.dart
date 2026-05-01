import 'package:flutter/material.dart';
import '../../flashx.dart';

/// Convenience extensions on [BuildContext] for showing FlashX notifications.
///
/// ```dart
/// context.flashSuccess("Profile saved!");
/// context.flashError("Something went wrong.");
/// ```
extension FlashXContextExtensions on BuildContext {
  /// Shows a success notification.
  void flashSuccess(String message, {String? title, FlashOptions? options}) {
    FlashX.success(message, title: title, options: options);
  }

  /// Shows an error notification.
  void flashError(String message, {String? title, FlashOptions? options}) {
    FlashX.error(message, title: title, options: options);
  }

  /// Shows a warning notification.
  void flashWarning(String message, {String? title, FlashOptions? options}) {
    FlashX.warning(message, title: title, options: options);
  }

  /// Shows an info notification.
  void flashInfo(String message, {String? title, FlashOptions? options}) {
    FlashX.info(message, title: title, options: options);
  }

  /// Shows a loading notification and returns its ID.
  int flashLoading(String message) {
    return FlashX.loading(message);
  }
}

/// Convenience extensions on [String] for one-liner toast calls.
///
/// ```dart
/// "Saved!".flashSuccess();
/// "Oops!".flashError();
/// ```
extension FlashXStringExtensions on String {
  /// Shows this string as a success notification.
  void flashSuccess({String? title}) => FlashX.success(this, title: title);

  /// Shows this string as an error notification.
  void flashError({String? title}) => FlashX.error(this, title: title);

  /// Shows this string as a warning notification.
  void flashWarning({String? title}) => FlashX.warning(this, title: title);

  /// Shows this string as an info notification.
  void flashInfo({String? title}) => FlashX.info(this, title: title);
}

/// Convenience extensions on [Future<T>] for tracking async operations.
///
/// ```dart
/// uploadData().flashFuture(
///   loading: "Uploading...",
///   success: (_) => "Done!",
///   error: (e) => "Failed: $e",
/// );
/// ```
extension FlashXFutureExtensions<T> on Future<T> {
  Future<T> flashFuture({
    String loading = 'Loading...',
    String Function(T result)? success,
    String Function(Object error)? error,
    String defaultSuccess = 'Done!',
    String defaultError = 'Something went wrong.',
  }) {
    return FlashX.future<T>(
      future: this,
      loading: loading,
      success: success != null ? (r) => success(r) : defaultSuccess,
      error: error != null ? (e) => error(e) : defaultError,
    );
  }
}
