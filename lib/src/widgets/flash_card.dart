import 'dart:ui';
import 'package:flutter/material.dart';

import '../enums/flash_enums.dart';
import '../models/flash_options.dart';
import '../themes/flash_theme_data.dart';
import '../utils/flash_icon_resolver.dart';
import 'flash_progress_bar.dart';
import 'flash_spinner.dart';

/// The visual notification card rendered by the FlashX overlay.
///
/// This widget is fully self-contained and theme-aware. It renders
/// the icon, title, message, action buttons, and progress bar.
class FlashCard extends StatelessWidget {
  final FlashOptions options;
  final FlashThemeData theme;
  final BorderRadius borderRadius;
  final VoidCallback? onDismiss;

  const FlashCard({
    super.key,
    required this.options,
    required this.theme,
    required this.borderRadius,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final content = options.customWidget ?? _buildContent(context, isRtl);

    Widget card = _buildCard(content);

    /// Progress Bar
    if (options.showProgress &&
        options.duration != null &&
        options.duration! > Duration.zero &&
        options.customWidget == null) {
      card = Stack(
        children: [
          card,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: borderRadius.bottomLeft,
                  bottomRight: borderRadius.bottomRight,
                ),
                child: FlashProgressBar(
                  color: theme.progressColor.withValues(alpha: 0.95),
                  duration: options.duration!,
                  borderRadius: BorderRadius.only(
                    bottomLeft: borderRadius.bottomLeft,
                    bottomRight: borderRadius.bottomRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Semantics(
      label: options.semanticLabel ??
          '${options.type.name}: ${options.message ?? ''}',
      child: card,
    );
  }

  Widget _buildCard(Widget content) {
    if (theme.glassmorphism) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.blurSigma,
            sigmaY: theme.blurSigma,
          ),
          child: _styledContainer(content),
        ),
      );
    }

    return _styledContainer(content);
  }

  Widget _styledContainer(Widget content) {
    final decoration = BoxDecoration(
      gradient: theme.gradient,
      color: theme.gradient == null ? theme.backgroundColor : null,
      borderRadius: borderRadius,
      border: theme.borderWidth > 0
          ? Border.all(
              color: theme.borderColor,
              width: theme.borderWidth,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: 0.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
      ],
    );

    return Container(
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }

  Widget _buildContent(BuildContext context, bool isRtl) {
    final icon = _buildIcon();
    final textSection = _buildTextSection(context);
    final actions = _buildActions(context);

    return Padding(
      padding: options.padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (options.showIcon) ...[
                icon,
                const SizedBox(width: 12),
              ],

              /// Text
              Expanded(child: textSection),

              /// Close Button
              _buildCloseButton(context),
            ],
          ),
          if (actions != null) ...[
            const SizedBox(height: 10),
            actions,
          ],
        ],
      ),
    );
  }

  /// ICON
  Widget _buildIcon() {
    if (options.type == FlashType.loading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: Center(
          child: FlashSpinner(
            color: theme.iconColor,
            size: 18,
          ),
        ),
      );
    }

    return SizedBox(
      height: 24,
      width: 24,
      child: Center(
        child: Icon(
          options.icon ?? FlashIconResolver.forType(options.type),
          color: theme.iconColor,
          size: 20,
        ),
      ),
    );
  }

  /// TEXT SECTION
  Widget _buildTextSection(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// TITLE
          if (options.title != null) ...[
            Text(
              options.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.15,
                height: 1.3,
              ),
            ),
            if (options.message != null) const SizedBox(height: 3),
          ],

          /// MESSAGE
          if (options.message != null)
            Text(
              options.message!,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.textColor.withValues(
                  alpha: options.title != null ? 0.82 : 1.0,
                ),
                fontSize: options.title != null ? 13 : 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
        ],
      ),
    );
  }

  /// CLOSE BUTTON
  Widget _buildCloseButton(BuildContext context) {
    if (onDismiss == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          top: 2,
        ),
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: theme.textColor.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: theme.textColor.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  /// ACTIONS
  Widget? _buildActions(BuildContext context) {
    if (options.actionText == null && options.secondaryActionText == null) {
      return null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (options.secondaryActionText != null) ...[
          _actionButton(
            options.secondaryActionText!,
            options.onSecondaryAction,
            context,
            secondary: true,
          ),
          const SizedBox(width: 8),
        ],
        if (options.actionText != null)
          _actionButton(
            options.actionText!,
            options.onAction,
            context,
          ),
      ],
    );
  }

  /// ACTION BUTTON
  Widget _actionButton(
    String label,
    VoidCallback? callback,
    BuildContext context, {
    bool secondary = false,
  }) {
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        foregroundColor: theme.actionColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: secondary ? FontWeight.w500 : FontWeight.w700,
          letterSpacing: 0.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: secondary
              ? BorderSide(
                  color: theme.actionColor.withValues(alpha: 0.25),
                )
              : BorderSide.none,
        ),
      ),
      child: Text(label),
    );
  }
}
