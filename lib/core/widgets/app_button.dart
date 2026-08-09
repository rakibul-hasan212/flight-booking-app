import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isPrimary ? theme.colorScheme.primary : theme.colorScheme.secondary,
      foregroundColor: isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p24,
        vertical: AppSizes.p16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );

    final childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: AppSizes.p8),
        ],
        Text(title),
      ],
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: onPressed,
          child: childContent,
        ),
      );
    }

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: childContent,
    );
  }
}
