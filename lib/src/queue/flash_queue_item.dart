import '../enums/flash_enums.dart';
import '../models/flash_options.dart';

/// Internal wrapper around [FlashOptions] with queue metadata.
class FlashQueueItem {
  /// The notification options.
  final FlashOptions options;

  /// Monotonically-increasing ID assigned when the item enters the queue.
  final int id;

  /// Wall-clock time when the item was enqueued.
  final DateTime enqueuedAt;

  /// Completer callback invoked when this item finishes displaying.
  final void Function()? onComplete;

  const FlashQueueItem({
    required this.options,
    required this.id,
    required this.enqueuedAt,
    this.onComplete,
  });

  /// Convenience accessor for the item's priority.
  FlashPriority get priority => options.priority;

  /// Convenience accessor for the item's de-dupe key.
  String? get dedupeKey => options.key;
}
