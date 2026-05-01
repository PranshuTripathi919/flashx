import 'package:flutter/material.dart';

/// Animated countdown progress bar displayed at the bottom of a notification.
class FlashProgressBar extends StatefulWidget {
  final Color color;
  final Duration duration;
  final BorderRadius? borderRadius;

  const FlashProgressBar({
    super.key,
    required this.color,
    required this.duration,
    this.borderRadius,
  });

  @override
  State<FlashProgressBar> createState() => _FlashProgressBarState();
}

class _FlashProgressBarState extends State<FlashProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: widget.borderRadius ??
              const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
          child: LinearProgressIndicator(
            value: 1.0 - _controller.value,
            backgroundColor: widget.color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 3,
          ),
        );
      },
    );
  }
}
