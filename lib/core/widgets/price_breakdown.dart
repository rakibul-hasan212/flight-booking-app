import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class PriceBreakdown extends StatelessWidget {
  final double baseFare;
  final double tax;
  final double insurance;
  final double discount;
  final double total;

  const PriceBreakdown({
    super.key,
    required this.baseFare,
    required this.tax,
    required this.insurance,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget itemRow(String label, String value, {bool isBold = false, Color? color}) {
      final style = theme.textTheme.bodyLarge?.copyWith(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color ?? (isBold ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.7)),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: style),
            Text(value, style: style),
          ],
        ),
      );
    }

    return Column(
      children: [
        itemRow('Base Fare', '\$${baseFare.toStringAsFixed(2)}'),
        if (insurance > 0)
          itemRow('Travel Insurance', '\$${insurance.toStringAsFixed(2)}'),
        itemRow('Tax', '\$${tax.toStringAsFixed(2)}'),
        if (discount > 0)
          itemRow('Discount', '-\$${discount.toStringAsFixed(2)}', color: theme.colorScheme.error),
        const SizedBox(height: AppSizes.p8),
        Divider(color: theme.dividerColor.withValues(alpha: 0.5)),
        const SizedBox(height: AppSizes.p8),
        itemRow('Total Amount', '\$${total.toStringAsFixed(2)}', isBold: true, color: theme.colorScheme.primary),
      ],
    );
  }
}
