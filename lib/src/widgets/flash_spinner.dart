import 'package:flutter/material.dart';

import '../../flashx.dart' show FlashType;

import '../enums/flash_enums.dart' show FlashType;

/// Animated spinner icon used in [FlashType.loading] notifications.
class FlashSpinner extends StatefulWidget {
  final Color color;
  final double size;

  const FlashSpinner({super.key, required this.color, this.size = 24});

  @override
  State<FlashSpinner> createState() => _FlashSpinnerState();
}

class _FlashSpinnerState extends State<FlashSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
        ),
      ),
    );
  }
}
