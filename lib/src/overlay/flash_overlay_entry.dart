import 'package:flutter/material.dart';
import '../animations/flash_animation_builder.dart';
import '../config/flash_config.dart';
import '../enums/flash_enums.dart';
import '../models/flash_options.dart';
import '../themes/flash_theme_data.dart';
import '../widgets/flash_card.dart';

/// The overlay widget that positions, animates, and provides swipe-dismiss
/// for a single [FlashOptions] notification.
class FlashOverlayEntry extends StatefulWidget {
  final FlashOptions options;
  final FlashThemeData theme;
  final FlashXConfig config;
  final VoidCallback onDismiss;

  const FlashOverlayEntry({
    super.key,
    required this.options,
    required this.theme,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<FlashOverlayEntry> createState() => FlashOverlayEntryState();
}

class FlashOverlayEntryState extends State<FlashOverlayEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _dismissed = false;
  double _dragOffsetX = 0;
  double _dragOffsetY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.options.animationDuration,
    );
    _controller.forward();

    // Auto-dismiss
    final dur = widget.options.duration;
    if (dur != null && dur > Duration.zero) {
      Future.delayed(dur, () {
        if (mounted && !_dismissed) dismiss();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Animates the exit and then calls [onDismiss].
  Future<void> dismiss() async {
    if (_dismissed || !mounted) return;
    _dismissed = true;
    await _controller.animateBack(
      0,
      duration: widget.options.exitAnimationDuration,
      curve: Curves.easeInCubic,
    );
    widget.onDismiss();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_canSwipe) return;
    setState(() {
      if (_isHorizontal) {
        _dragOffsetX += details.delta.dx;
      } else {
        _dragOffsetY += details.delta.dy;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_canSwipe) return;
    const threshold = 80.0;
    final velocity = _isHorizontal
        ? details.velocity.pixelsPerSecond.dx.abs()
        : details.velocity.pixelsPerSecond.dy.abs();

    if (_dragOffsetX.abs() > threshold ||
        _dragOffsetY.abs() > threshold ||
        velocity > 400) {
      dismiss();
    } else {
      setState(() {
        _dragOffsetX = 0;
        _dragOffsetY = 0;
      });
    }
  }

  bool get _canSwipe =>
      widget.options.dismissDirection != FlashDismissDirection.none;

  bool get _isHorizontal =>
      widget.options.dismissDirection == FlashDismissDirection.horizontal ||
      widget.options.dismissDirection == FlashDismissDirection.left ||
      widget.options.dismissDirection == FlashDismissDirection.right ||
      widget.options.dismissDirection == FlashDismissDirection.any;

  BorderRadius get _borderRadius =>
      widget.options.themeData?.borderRadius ?? widget.config.borderRadius;

  @override
  Widget build(BuildContext context) {
    final opts = widget.options;
    final pos = opts.position;

    Widget card = FlashCard(
      options: opts,
      theme: widget.theme,
      borderRadius: _borderRadius,
      onDismiss: dismiss,
    );

    if (opts.onTap != null) {
      card = GestureDetector(onTap: opts.onTap, child: card);
    }

    // Apply swipe drag offset
    if (_dragOffsetX != 0 || _dragOffsetY != 0) {
      final opacity = (1.0 - (_dragOffsetX.abs() + _dragOffsetY.abs()) / 200)
          .clamp(0.0, 1.0);
      card = Transform.translate(
        offset: Offset(_dragOffsetX, _dragOffsetY),
        child: Opacity(opacity: opacity, child: card),
      );
    }

    // Wrap with gesture detector for swipe
    if (_canSwipe) {
      card = GestureDetector(
        onHorizontalDragUpdate: _isHorizontal ? _handleDragUpdate : null,
        onHorizontalDragEnd: _isHorizontal ? _handleDragEnd : null,
        onVerticalDragUpdate: !_isHorizontal ? _handleDragUpdate : null,
        onVerticalDragEnd: !_isHorizontal ? _handleDragEnd : null,
        child: card,
      );
    }

    // Wrap with animation
    Widget animated;
    if (opts.animationBuilder != null) {
      animated = opts.animationBuilder!(_controller, card);
    } else {
      animated = FlashAnimationBuilder.build(
        animation: opts.animation,
        position: pos,
        controller: _controller,
        child: card,
      );
    }

    // Constrain width
    final screenWidth = MediaQuery.of(context).size.width;
    final maxW = opts.maxWidth ??
        widget.config.maxWidth ??
        (screenWidth > 600 ? 520.0 : double.infinity);


    // Compute vertical positioning via Stack + alignment
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Align(
          alignment: pos == FlashPosition.top
              ? Alignment.topCenter
              : pos == FlashPosition.bottom
                  ? Alignment.bottomCenter
                  : Alignment.center,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: opts.marginHorizontal,
                vertical: opts.marginVertical,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: animated,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
