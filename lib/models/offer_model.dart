class OfferModel {
  final String id;
  final String title;
  final String description;
  final String discountCode;
  final double discountValue; // Value or percentage
  final bool isPercentage;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountCode,
    required this.discountValue,
    required this.isPercentage,
  });
}
