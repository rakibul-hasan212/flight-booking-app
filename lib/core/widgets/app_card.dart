import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderSide? borderSide;
  final double? radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderSide,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardTheme.color;
    final shape = theme.cardTheme.shape as RoundedRectangleBorder?;

    return Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(radius ?? AppSizes.r16),
        border: borderSide != null
            ? Border.fromBorderSide(borderSide!)
            : (shape?.side != null
                ? Border.fromBorderSide(shape!.side)
                : Border.all(color: theme.dividerColor.withValues(alpha: 0.1))),
      ),
      child: child,
    );
  }
}
