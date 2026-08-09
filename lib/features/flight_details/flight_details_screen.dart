import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/flight_route_widget.dart';
import '../../models/flight_model.dart';

class FlightDetailsScreen extends StatelessWidget {
  final FlightModel flight;

  const FlightDetailsScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom helper row to display amenities cleanly
    Widget buildAmenityItem(IconData icon, String title, String subtitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: AppSizes.iconMedium,
              ),
            ),
            const SizedBox(width: AppSizes.p16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flight Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Airline Header Card
                    AppCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSizes.p12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                            child: Text(
                              flight.airlineLogo,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.p16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.airline,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppSizes.p4),
                              Text(
                                'Flight Date: ${flight.date}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // 2. Flight Route Visualization Card
                    AppCard(
                      child: Column(
                        children: [
                          FlightRouteWidget(
                            departureCode: flight.departureAirport,
                            departureCity: flight.departureCity,
                            departureTime: flight.departureTime,
                            arrivalCode: flight.arrivalAirport,
                            arrivalCity: flight.arrivalCity,
                            arrivalTime: flight.arrivalTime,
                            duration: flight.duration,
                            stops: flight.stops,
                          ),
                          const SizedBox(height: AppSizes.p16),
                          Divider(color: theme.dividerColor.withValues(alpha: 0.3)),
                          const SizedBox(height: AppSizes.p16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price Per Seat',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${flight.currency}${flight.price.toStringAsFixed(2)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // 3. Baggage and Flight Policies (Amenities)
                    Text(
                      'Baggage & Policies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppCard(
                      child: Column(
                        children: [
                          buildAmenityItem(
                            Icons.card_travel,
                            'Cabin Baggage',
                            flight.cabinBaggage,
                          ),
                          const Divider(),
                          buildAmenityItem(
                            Icons.backpack_outlined,
                            'Check-in Baggage',
                            flight.baggage,
                          ),
                          const Divider(),
                          buildAmenityItem(
                            Icons.currency_exchange,
                            'Refund Policy',
                            flight.refundPolicy,
                          ),
                          const Divider(),
                          buildAmenityItem(
                            Icons.verified_user_outlined,
                            'Travel Insurance',
                            flight.insuranceIncluded
                                ? 'Included (Free)'
                                : 'Not Included (\$45.00 available)',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Continue Bottom Action Card
            Container(
              padding: const EdgeInsets.all(AppSizes.p20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: AppButton(
                title: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.flightBooking,
                    arguments: flight,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
