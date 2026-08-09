import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class BookingProgressIndicator extends StatelessWidget {
  final int currentStep; // 1 = Book, 2 = Pay, 3 = Done

  const BookingProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildStep(int stepNumber, String title) {
      final isActive = currentStep == stepNumber;
      final isCompleted = currentStep > stepNumber;

      Color circleColor;
      Color textColor;
      Color borderColor;
      Widget stepContent;

      if (isCompleted) {
        circleColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.primary;
        stepContent = const Icon(
          Icons.check,
          color: Colors.white,
          size: AppSizes.iconSmall,
        );
      } else if (isActive) {
        circleColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.primary;
        stepContent = Text(
          stepNumber.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        circleColor = Colors.transparent;
        borderColor = theme.dividerColor;
        textColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
        stepContent = Text(
          stepNumber.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        );
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: stepContent,
          ),
          const SizedBox(width: AppSizes.p8),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      );
    }

    Widget buildLine(int stepNumber) {
      final isCompleted = currentStep > stepNumber;
      return Expanded(
        child: Container(
          height: 2,
          color: isCompleted ? theme.colorScheme.primary : theme.dividerColor,
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.p8),
        ),
      );
    }

    return Row(
      children: [
        buildStep(1, 'Book'),
        buildLine(1),
        buildStep(2, 'Pay'),
        buildLine(2),
        buildStep(3, 'Done'),
      ],
    );
  }
}
