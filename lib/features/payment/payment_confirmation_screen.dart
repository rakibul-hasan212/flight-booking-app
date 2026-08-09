import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/booking_progress_indicator.dart';
import '../../core/widgets/payment_method_tile.dart';
import '../../core/widgets/price_breakdown.dart';
import '../../data/static_data/offer_data.dart';
import '../../models/booking_model.dart';
import '../../models/flight_model.dart';
import '../../models/passenger_model.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final FlightModel flight;
  final PassengerModel passenger;

  const PaymentConfirmationScreen({
    super.key,
    required this.flight,
    required this.passenger,
  });

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  String _selectedPaymentMethod = 'My Wallet';
  final _voucherController = TextEditingController();

  double _baseFare = 0.0;
  final double _tax = 25.00;
  double _insurance = 0.0;
  double _discount = 0.0;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _baseFare = widget.flight.price;
    _insurance = widget.flight.insuranceIncluded ? 0.00 : 45.00;
    _calculateTotal();
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    setState(() {
      _total = _baseFare + _insurance + _tax - _discount;
      if (_total < 0) _total = 0.0;
    });
  }

  void _applyVoucher() {
    final code = _voucherController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    final matchingOffers = OfferData.offers.where(
      (offer) => offer.discountCode.toUpperCase() == code,
    );

    if (matchingOffers.isNotEmpty) {
      final matchedOffer = matchingOffers.first;
      setState(() {
        if (matchedOffer.isPercentage) {
          _discount = _baseFare * matchedOffer.discountValue;
        } else {
          _discount = matchedOffer.discountValue;
        }
        _calculateTotal();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code applied successfully! Saved \$${_discount.toStringAsFixed(2)}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _generateBookingId() {
    final rand = Random();
    final digits = List.generate(8, (_) => rand.nextInt(10).toString()).join();
    return 'BKG$digits';
  }

  String _generateSeatNumber() {
    final rand = Random();
    final row = rand.nextInt(30) + 1; // Row 1 to 30
    final seatLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
    final letter = seatLetters[rand.nextInt(seatLetters.length)];
    return '$letter$row';
  }

  void _onPayNowPressed() {
    final bookingId = _generateBookingId();
    final seat = _generateSeatNumber();
    final flightNumber = '${widget.flight.airlineLogo}${100 + Random().nextInt(900)}';
    final gate = (Random().nextInt(30) + 1).toString();

    final booking = BookingModel(
      bookingId: bookingId,
      flight: widget.flight,
      passenger: widget.passenger,
      seatNumber: seat,
      baseFare: _baseFare,
      tax: _tax,
      discount: _discount,
      totalAmount: _total,
      paymentMethod: _selectedPaymentMethod,
      flightNumber: flightNumber,
      gate: gate,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.eTicket,
      arguments: booking,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Confirmation',
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
            // 1. Progress Step Tracker (Step 2: Pay)
            const Padding(
              padding: EdgeInsets.all(AppSizes.p16),
              child: BookingProgressIndicator(currentStep: 2),
            ),

            // Scrollable Payment Details Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Flight Summary Card (Compact)
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                      '${widget.flight.departureCity} to ${widget.flight.arrivalCity}',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${widget.flight.airline} • ${widget.flight.stops}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: AppSizes.p24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Passenger',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                widget.passenger.fullName,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // 3. Payment Methods Selection
                    Text(
                      'Select Payment Method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    PaymentMethodTile(
                      title: 'My Wallet',
                      icon: Icons.account_balance_wallet_outlined,
                      isSelected: _selectedPaymentMethod == 'My Wallet',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'My Wallet';
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.p8),
                    PaymentMethodTile(
                      title: 'Visa / Mastercard',
                      icon: Icons.credit_card_outlined,
                      isSelected: _selectedPaymentMethod == 'Visa / Mastercard',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Visa / Mastercard';
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.p8),
                    PaymentMethodTile(
                      title: 'Mobile Banking',
                      icon: Icons.phone_android_outlined,
                      isSelected: _selectedPaymentMethod == 'Mobile Banking',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Mobile Banking';
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // 4. Voucher Discount Applied
                    Text(
                      'Apply Promo Code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherController,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'Enter Promo Code (e.g. VX25)',
                              hintStyle: theme.textTheme.bodyMedium,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.p16,
                                vertical: AppSizes.p12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.p12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p20,
                              vertical: AppSizes.p16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                          ),
                          onPressed: _applyVoucher,
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // 5. Price Breakdown details
                    Text(
                      'Price Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),
                    AppCard(
                      child: PriceBreakdown(
                        baseFare: _baseFare,
                        tax: _tax,
                        insurance: _insurance,
                        discount: _discount,
                        total: _total,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p24),
                  ],
                ),
              ),
            ),

            // Continue CTA Bottom Action Box
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
                title: 'Pay Now (\$${_total.toStringAsFixed(2)})',
                onPressed: _onPayNowPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
