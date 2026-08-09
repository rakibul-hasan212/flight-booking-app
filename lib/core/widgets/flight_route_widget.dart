import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class FlightRouteWidget extends StatelessWidget {
  final String departureCode;
  final String departureCity;
  final String departureTime;
  final String arrivalCode;
  final String arrivalCity;
  final String arrivalTime;
  final String duration;
  final String stops;
  final bool showCityNames;

  const FlightRouteWidget({
    super.key,
    required this.departureCode,
    required this.departureCity,
    required this.departureTime,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    this.showCityNames = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Departure
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                departureTime,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.p4),
              Text(
                departureCode,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (showCityNames) ...[
                const SizedBox(height: AppSizes.p4),
                Text(
                  departureCity,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),

        // Route Visual
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                duration,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSizes.p4),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: theme.dividerColor,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p4),
                  Transform.rotate(
                    angle: 1.5708, // Rotate plane icon 90 degrees to point right
                    child: Icon(
                      Icons.airplanemode_active,
                      color: theme.colorScheme.primary,
                      size: AppSizes.iconSmall + 2,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p4),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: theme.dividerColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p4),
              Text(
                stops,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: stops.toLowerCase() == 'direct'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Arrival
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                arrivalTime,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.p4),
              Text(
                arrivalCode,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (showCityNames) ...[
                const SizedBox(height: AppSizes.p4),
                Text(
                  arrivalCity,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
