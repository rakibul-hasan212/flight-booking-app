import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/booking_progress_indicator.dart';
import '../../models/flight_model.dart';
import '../../models/passenger_model.dart';

class FlightBookingScreen extends StatefulWidget {
  final FlightModel flight;

  const FlightBookingScreen({super.key, required this.flight});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    if (_formKey.currentState!.validate()) {
      final passenger = PassengerModel(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        passportNumber: _passportController.text.trim().toUpperCase(),
      );

      Navigator.pushNamed(
        context,
        AppRoutes.paymentConfirmation,
        arguments: {
          'flight': widget.flight,
          'passenger': passenger,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Flight',
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
            // 1. Progress Step Tracker
            const Padding(
              padding: EdgeInsets.all(AppSizes.p16),
              child: BookingProgressIndicator(currentStep: 1),
            ),

            // Scrollable Form Layout (Keyboard Safe)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Flight Summary Card (Compact)
                      AppCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSizes.p8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSizes.r12),
                              ),
                              child: Text(
                                widget.flight.airlineLogo,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.p16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.flight.departureCity} (${widget.flight.departureAirport}) ➔ ${widget.flight.arrivalCity} (${widget.flight.arrivalAirport})',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p4),
                                  Text(
                                    '${widget.flight.airline} • ${widget.flight.departureTime} - ${widget.flight.arrivalTime} (${widget.flight.stops})',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.p24),

                      // Section Title
                      Text(
                        'Passenger Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p16),

                      // Full Name
                      AppTextField(
                        label: 'Full Name',
                        hintText: 'e.g. Mr. Andrew Ainsley',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.p16),

                      // Email Address
                      AppTextField(
                        label: 'Email',
                        hintText: 'e.g. andrew@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email cannot be empty.';
                          }
                          final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(value.trim())) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.p16),

                      // Phone Number
                      AppTextField(
                        label: 'Phone Number',
                        hintText: 'e.g. +1 111 467 378 399',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.p16),

                      // Passport Number
                      AppTextField(
                        label: 'Passport Number',
                        hintText: 'e.g. A12345678',
                        controller: _passportController,
                        prefixIcon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Passport number cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.p24),
                    ],
                  ),
                ),
              ),
            ),

            // Continue CTA Bottom Box
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
                title: 'Continue to Payment',
                onPressed: _onContinuePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
