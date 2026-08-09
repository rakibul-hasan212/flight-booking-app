import '../../models/offer_model.dart';

class OfferData {
  static const List<OfferModel> offers = [
    OfferModel(
      id: 'OFF001',
      title: 'Summer Flight Deals',
      description: 'Book now and save 25% on select international routes.',
      discountCode: 'VX25',
      discountValue: 0.25,
      isPercentage: true,
    ),
    OfferModel(
      id: 'OFF002',
      title: 'First Booking Discount',
      description: r'Get a flat $50 discount on your first flight ticket.',
      discountCode: 'WELCOME50',
      discountValue: 50.00,
      isPercentage: false,
    ),
    OfferModel(
      id: 'OFF003',
      title: 'Premium Class Deal',
      description: 'Upgrade your experience with 15% off on Business and First class.',
      discountCode: 'PREMIUM15',
      discountValue: 0.15,
      isPercentage: true,
    ),
  ];
}
