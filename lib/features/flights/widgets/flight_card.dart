import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/flight_route_widget.dart';
import '../../../models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onTap;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic Airline Icon / Logo generator using letters if no logo asset
    Widget airlineLogoIndicator() {
      return Container(
        padding: const EdgeInsets.all(AppSizes.p8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
        child: Text(
          flight.airlineLogo,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          children: [
            // Top Row: Logo, Name, and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    airlineLogoIndicator(),
                    const SizedBox(width: AppSizes.p12),
                    Text(
                      flight.airline,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${flight.currency}${flight.price.toStringAsFixed(0)} /pax',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p16),

            // Middle Route Details Visual
            FlightRouteWidget(
              departureCode: flight.departureAirport,
              departureCity: flight.departureCity,
              departureTime: flight.departureTime,
              arrivalCode: flight.arrivalAirport,
              arrivalCity: flight.arrivalCity,
              arrivalTime: flight.arrivalTime,
              duration: flight.duration,
              stops: flight.stops,
              showCityNames: true,
            ),
          ],
        ),
      ),
    );
  }
}
