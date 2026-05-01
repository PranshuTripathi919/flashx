import 'package:flutter/material.dart';

import '../../flashx.dart';
import '../controllers/flash_controller.dart';

/// Optional but recommended wrapper widget that registers the nearest
/// [OverlayState] with [FlashX].
///
/// Wrap your [MaterialApp] builder or any subtree to ensure FlashX can find
/// the overlay without requiring a [navigatorKey]:
///
/// ```dart
/// MaterialApp(
///   builder: FlashXWidget.init(),
///   home: HomeScreen(),
/// );
/// ```
///
/// Or place it explicitly:
///
/// ```dart
/// FlashXWidget(child: MyApp())
/// ```
class FlashXWidget extends StatefulWidget {
  final Widget child;

  const FlashXWidget({super.key, required this.child});

  /// Convenience [TransitionBuilder] for use with [MaterialApp.builder].
  ///
  /// ```dart
  /// MaterialApp(
  ///   builder: FlashXWidget.init(),
  /// )
  /// ```
  static TransitionBuilder init({TransitionBuilder? builder}) {
    return (context, child) {
      if (builder != null) {
        return builder(context, FlashXWidget(child: child!));
      }
      return FlashXWidget(child: child!);
    };
  }

  @override
  State<FlashXWidget> createState() => _FlashXWidgetState();
}

class _FlashXWidgetState extends State<FlashXWidget> {
  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (_) => _FlashXOverlayConnector(child: widget.child),
        ),
      ],
    );
  }
}

/// Internal widget that connects the overlay to the [FlashController].
class _FlashXOverlayConnector extends StatefulWidget {
  final Widget child;
  const _FlashXOverlayConnector({required this.child});

  @override
  State<_FlashXOverlayConnector> createState() =>
      _FlashXOverlayConnectorState();
}

class _FlashXOverlayConnectorState extends State<_FlashXOverlayConnector> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final overlay = Overlay.maybeOf(context);
    if (overlay != null) {
      FlashX.controller.attachOverlay(overlay);
    }
  }

  @override
  void dispose() {
    FlashX.controller.detachOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
