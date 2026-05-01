import 'package:flutter/material.dart';
import '../enums/flash_enums.dart';

/// Maps [FlashType] to a default [IconData].
class FlashIconResolver {
  const FlashIconResolver._();

  static IconData forType(FlashType type) {
    switch (type) {
      case FlashType.success:
        return Icons.check_circle_rounded;
      case FlashType.error:
        return Icons.cancel_rounded;
      case FlashType.warning:
        return Icons.warning_rounded;
      case FlashType.info:
        return Icons.info_rounded;
      case FlashType.loading:
        return Icons.hourglass_top_rounded;
      case FlashType.custom:
        return Icons.notifications_rounded;
    }
  }
}
