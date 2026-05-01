import 'dart:collection';
import '../enums/flash_enums.dart';
import 'flash_queue_item.dart';

/// Manages the ordered queue of pending [FlashQueueItem]s.
///
/// Items are sorted by [FlashPriority]: critical → high → normal.
/// Within the same priority, insertion order (FIFO) is preserved.
class FlashQueue {
  final _queue = ListQueue<FlashQueueItem>();
  int _nextId = 0;

  /// The set of de-dupe keys currently active (visible or queued).
  final _activeKeys = <String>{};

  /// Whether any items are waiting in the queue.
  bool get isEmpty => _queue.isEmpty;

  /// Number of items in the queue.
  int get length => _queue.length;

  /// Adds [item] to the queue, respecting priority ordering and de-duplication.
  ///
  /// Returns `true` if the item was added, `false` if it was rejected.
  bool enqueue(FlashQueueItem item) {
    // De-dupe check
    if (item.dedupeKey != null && _activeKeys.contains(item.dedupeKey)) {
      return false;
    }

    if (item.dedupeKey != null) {
      _activeKeys.add(item.dedupeKey!);
    }

    // Critical priority items go straight to the front
    if (item.priority == FlashPriority.critical) {
      _queue.addFirst(item);
      return true;
    }

    // High priority items insert before normal items but after other high/critical
    if (item.priority == FlashPriority.high) {
      final list = _queue.toList();
      int insertAt = list.length;
      for (int i = 0; i < list.length; i++) {
        if (list[i].priority == FlashPriority.normal) {
          insertAt = i;
          break;
        }
      }
      _queue.clear();
      for (int i = 0; i < list.length; i++) {
        if (i == insertAt) _queue.add(item);
        _queue.add(list[i]);
      }
      if (insertAt == list.length) _queue.add(item);
      return true;
    }

    // Normal priority — append to end
    _queue.add(item);
    return true;
  }

  /// Removes and returns the next item to be displayed, or [null] if empty.
  FlashQueueItem? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  /// Peeks at the next item without removing it.
  FlashQueueItem? peek() {
    if (_queue.isEmpty) return null;
    return _queue.first;
  }

  /// Creates a new [FlashQueueItem] from raw options fields, assigns it
  /// an ID, and enqueues it.
  int createId() => _nextId++;

  /// Removes the de-dupe key from the active set (call when item is dismissed).
  void releaseKey(String? key) {
    if (key != null) _activeKeys.remove(key);
  }

  /// Clears all queued items.
  void clear() {
    _queue.clear();
    _activeKeys.clear();
  }

  /// Removes all items matching a de-dupe key.
  void removeByKey(String key) {
    _queue.removeWhere((item) => item.dedupeKey == key);
    _activeKeys.remove(key);
  }
}
