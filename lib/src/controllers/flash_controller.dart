import 'package:flutter/material.dart';
import '../../flashx.dart' show FlashX, FlashXWidget;
import '../config/flash_config.dart';
import '../models/flash_options.dart';
import '../overlay/flash_overlay_entry.dart';
import '../queue/flash_queue.dart';
import '../queue/flash_queue_item.dart';
import '../themes/flash_theme_data.dart';

/// Internal controller that owns the [OverlayState], the queue, and all
/// active notification entries.
///
/// There is typically one global instance managed by [FlashX].
class FlashController {
  FlashXConfig _config;
  OverlayState? _overlayState;

  final FlashQueue _queue = FlashQueue();

  /// Currently active (visible) overlay entries, keyed by their queue ID.
  final Map<int, _ActiveEntry> _active = {};

  bool _processing = false;

  FlashController({FlashXConfig? config})
      : _config = config ?? const FlashXConfig();

  // ─── Public API ─────────────────────────────────────────────────────────────

  /// Updates the global config.
  void configure(FlashXConfig config) => _config = config;

  /// Returns the current config.
  FlashXConfig get config => _config;

  /// Attaches an [OverlayState] (from [FlashXWidget] or [navigatorKey]).
  void attachOverlay(OverlayState overlay) {
    _overlayState = overlay;
  }

  /// Detaches the [OverlayState].
  void detachOverlay() {
    _overlayState = null;
  }

  /// Enqueues a notification. Returns the assigned queue ID, or -1 if rejected.
  int enqueue(FlashOptions options) {
    final id = _queue.createId();
    final item = FlashQueueItem(
      options: _applyDefaults(options),
      id: id,
      enqueuedAt: DateTime.now(),
    );
    final accepted = _queue.enqueue(item);
    if (!accepted) return -1;
    _processQueue();
    return id;
  }

  /// Immediately dismisses all visible notifications and clears the queue.
  Future<void> dismissAll() async {
    _queue.clear();
    final entries = List<_ActiveEntry>.from(_active.values);
    for (final entry in entries) {
      await entry.stateKey.currentState?.dismiss();
    }
  }

  /// Dismisses a specific notification by its queue ID.
  Future<void> dismissById(int id) async {
    final entry = _active[id];
    if (entry != null) {
      await entry.stateKey.currentState?.dismiss();
    }
  }

  // ─── Private ────────────────────────────────────────────────────────────────

  void _processQueue() {
    if (_processing) return;
    _processing = true;
    _drainQueue();
  }

  void _drainQueue() {
    if (_overlayState == null || !_overlayState!.mounted) {
      _processing = false;
      return;
    }

    // Respect maxVisible
    if (_active.length >= _config.maxVisible) {
      _processing = false;
      return;
    }

    final item = _queue.dequeue();
    if (item == null) {
      _processing = false;
      return;
    }

    _showItem(item);
  }

  void _showItem(FlashQueueItem item) {
    if (_overlayState == null) return;

    final stateKey = GlobalKey<FlashOverlayEntryState>();
    final theme = _resolveTheme(item.options);

    final overlayEntry = OverlayEntry(
      builder: (context) => FlashOverlayEntry(
        key: stateKey,
        options: item.options,
        theme: theme,
        config: _config,
        onDismiss: () => _onItemDismissed(item),
      ),
    );

    _active[item.id] = _ActiveEntry(
      overlayEntry: overlayEntry,
      stateKey: stateKey,
      item: item,
    );

    _overlayState!.insert(overlayEntry);

    // After showing one, check if we can show another (stacked mode)
    if (_config.stackedMode) {
      Future.microtask(_drainQueue);
    } else {
      _processing = false;
    }
  }

  void _onItemDismissed(FlashQueueItem item) {
    final entry = _active.remove(item.id);
    entry?.overlayEntry.remove();
    _queue.releaseKey(item.dedupeKey);
    item.onComplete?.call();

    // Try to show next
    _processing = false;
    _processQueue();
  }

  FlashThemeData _resolveTheme(FlashOptions options) {
    if (options.themeData != null) return options.themeData!;
    if (_config.typeThemeOverrides.containsKey(options.type)) {
      return _config.typeThemeOverrides[options.type]!;
    }
    final brightness = _currentBrightness();
    return FlashThemeData.forType(options.type, brightness);
  }

  Brightness _currentBrightness() {
    final context = _overlayState?.context;
    if (context == null) return Brightness.light;
    return MediaQuery.maybeOf(context)?.platformBrightness ?? Brightness.light;
  }

  FlashOptions _applyDefaults(FlashOptions options) {
    return options.copyWith(
      position: options.position,
      animation: options.animation,
      animationDuration: options.animationDuration,
      exitAnimationDuration: options.exitAnimationDuration,
      duration: options.duration ?? _config.duration,
      marginHorizontal: options.marginHorizontal,
      marginVertical: options.marginVertical,
      showProgress: options.showProgress,
      dismissDirection: options.dismissDirection,
    );
  }
}

class _ActiveEntry {
  final OverlayEntry overlayEntry;
  final GlobalKey<FlashOverlayEntryState> stateKey;
  final FlashQueueItem item;

  const _ActiveEntry({
    required this.overlayEntry,
    required this.stateKey,
    required this.item,
  });
}
