import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

/// Container with a mihrab (Islamic arch) shape — top-only radius of 100px.
class ArchContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const ArchContainer({
    super.key,
    required this.child,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(
        top: 48,
        left: AppSpacing.cardPadding,
        right: AppSpacing.cardPadding,
        bottom: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.archRadius),
          topRight: Radius.circular(AppSpacing.archRadius),
          bottomLeft: Radius.circular(AppSpacing.radiusXl),
          bottomRight: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: child,
    );
  }
}

/// Clip widget that masks its child into an arch (mihrab) shape.
class ArchClip extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const ArchClip({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.archRadius),
          topRight: Radius.circular(AppSpacing.archRadius),
          bottomLeft: Radius.circular(AppSpacing.radiusXl),
          bottomRight: Radius.circular(AppSpacing.radiusXl),
        ),
        child: child,
      ),
    );
  }
}
