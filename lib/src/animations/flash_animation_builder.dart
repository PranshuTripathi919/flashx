import 'package:flutter/material.dart';
import '../enums/flash_enums.dart';

/// Builds entrance and exit transitions for [FlashAnimation] presets.
class FlashAnimationBuilder {
  const FlashAnimationBuilder._();

  /// Returns an [Animation<Offset>] slide offset for [animation] based on
  /// [position] and whether this is an entrance or exit.
  static Widget build({
    required FlashAnimation animation,
    required FlashPosition position,
    required AnimationController controller,
    required Widget child,
    bool entering = true,
  }) {
    switch (animation) {
      case FlashAnimation.slide:
        return _slideTransition(controller, position, child);
      case FlashAnimation.fade:
        return _fadeTransition(controller, child);
      case FlashAnimation.scale:
        return _scaleTransition(controller, child);
      case FlashAnimation.elastic:
        return _elasticTransition(controller, child, position);
      case FlashAnimation.bounce:
        return _bounceTransition(controller, child, position);
      case FlashAnimation.rotation:
        return _rotationTransition(controller, child);
      case FlashAnimation.ios:
        return _iosTransition(controller, position, child);
    }
  }

  // ─── Slide ──────────────────────────────────────────────────────────────────

  static Widget _slideTransition(
    AnimationController controller,
    FlashPosition position,
    Widget child,
  ) {
    final Offset begin = _offsetForPosition(position);
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return SlideTransition(
      position:
          Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
      child: child,
    );
  }

  // ─── Fade ───────────────────────────────────────────────────────────────────

  static Widget _fadeTransition(AnimationController controller, Widget child) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    return FadeTransition(opacity: animation, child: child);
  }

  // ─── Scale ──────────────────────────────────────────────────────────────────

  static Widget _scaleTransition(AnimationController controller, Widget child) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    return ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }

  // ─── Elastic ────────────────────────────────────────────────────────────────

  static Widget _elasticTransition(
    AnimationController controller,
    Widget child,
    FlashPosition position,
  ) {
    final slideAnimation = CurvedAnimation(
      parent: controller,
      curve: const ElasticOutCurve(0.6),
      reverseCurve: Curves.easeInCubic,
    );
    final fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: Curves.easeIn,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: _offsetForPosition(position),
        end: Offset.zero,
      ).animate(slideAnimation),
      child: FadeTransition(opacity: fadeAnimation, child: child),
    );
  }

  // ─── Bounce ─────────────────────────────────────────────────────────────────

  static Widget _bounceTransition(
    AnimationController controller,
    Widget child,
    FlashPosition position,
  ) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.bounceOut,
      reverseCurve: Curves.easeInCubic,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: _offsetForPosition(position),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.3),
        ),
        child: child,
      ),
    );
  }

  // ─── Rotation ───────────────────────────────────────────────────────────────

  static Widget _rotationTransition(
      AnimationController controller, Widget child) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    return RotationTransition(
      turns: Tween<double>(begin: 0.02, end: 0.0).animate(animation),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  // ─── iOS ────────────────────────────────────────────────────────────────────

  static Widget _iosTransition(
    AnimationController controller,
    FlashPosition position,
    Widget child,
  ) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInCubic,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: _offsetForPosition(position),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.6, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  static Offset _offsetForPosition(FlashPosition position) {
    switch (position) {
      case FlashPosition.top:
        return const Offset(0, -1.5);
      case FlashPosition.bottom:
        return const Offset(0, 1.5);
      case FlashPosition.center:
        return const Offset(0, -0.3);
    }
  }
}
