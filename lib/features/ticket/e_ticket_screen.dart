import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_button.dart';
import '../../models/booking_model.dart';

class ETicketScreen extends StatelessWidget {
  final BookingModel booking;

  const ETicketScreen({super.key, required this.booking});

  void _shareTicket() {
    // ignore: deprecated_member_use
    Share.share(
      'Flight Booking Confirmation\n\n'
      'Passenger: ${booking.passenger.fullName}\n'
      'Flight: ${booking.flightNumber}\n'
      'Route: ${booking.flight.departureCity} (${booking.flight.departureAirport}) ➔ ${booking.flight.arrivalCity} (${booking.flight.arrivalAirport})\n'
      'Date: ${booking.flight.date}\n'
      'Time: ${booking.flight.departureTime} ➔ ${booking.flight.arrivalTime}\n'
      'Seat: ${booking.seatNumber}\n'
      'Booking ID: ${booking.bookingId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget detailsRow(String label1, String value1, String label2, String value2) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: AppSizes.fontCaption,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p2),
                  Text(
                    value1,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: AppSizes.fontCaption,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p2),
                  Text(
                    value2,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      // Keep solid branded blue background even in dark mode for real ticket scanners contrast
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        title: Text(
          'E-Ticket',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareTicket,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.r24),
                    ),
                    padding: const EdgeInsets.all(AppSizes.p20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Barcode Widget
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: AppSizes.p8),
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: booking.bookingId,
                                width: double.infinity,
                                height: 70,
                                drawText: false,
                                color: Colors.black,
                              ),
                              const SizedBox(height: AppSizes.p8),
                              Text(
                                booking.bookingId,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: AppSizes.p4),
                              Text(
                                'Show your ID and this barcode at the check-in gate',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: AppSizes.fontCaption,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.p20),

                        // Dashed divider line
                        Row(
                          children: List.generate(
                            30,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0 ? Colors.transparent : Colors.grey[300],
                                height: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.p20),

                        // 2. Flight Header Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.flight.airline,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              booking.flight.date,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.p16),

                        // 3. Route Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.flight.departureTime,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  booking.flight.departureAirport,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  booking.flight.departureCity,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.airplanemode_active,
                                  color: AppColors.primaryBlue,
                                  size: AppSizes.iconMedium,
                                ),
                                Text(
                                  booking.flight.duration,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  booking.flight.arrivalTime,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  booking.flight.arrivalAirport,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  booking.flight.arrivalCity,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.p20),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: AppSizes.p8),

                        // 4. Passenger and Booking Details Grid
                        detailsRow('Passenger Name', booking.passenger.fullName, 'Class', booking.flight.cabinBaggage == '7 kg' ? 'Economy' : 'Business'),
                        detailsRow('Email', booking.passenger.email, 'Phone Number', booking.passenger.phone),
                        detailsRow('Flight Number', booking.flightNumber, 'Booking ID', booking.bookingId),
                        detailsRow('Gate', booking.gate, 'Seat Number', booking.seatNumber),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p20),

              // Done / Close CTA Button (brings user back to Home cleanly)
              AppButton(
                title: 'Go to Home',
                isPrimary: false,
                icon: const Icon(Icons.home_outlined, color: AppColors.primaryBlue),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
