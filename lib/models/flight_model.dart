class FlightModel {
  final String id;
  final String airline;
  final String airlineLogo;
  final String departureAirport;
  final String departureCity;
  final String departureTime;
  final String arrivalAirport;
  final String arrivalCity;
  final String arrivalTime;
  final String duration;
  final String stops;
  final double price;
  final String currency;
  final String date;
  final String baggage;
  final String cabinBaggage;
  final String refundPolicy;
  final bool insuranceIncluded;

  const FlightModel({
    required this.id,
    required this.airline,
    required this.airlineLogo,
    required this.departureAirport,
    required this.departureCity,
    required this.departureTime,
    required this.arrivalAirport,
    required this.arrivalCity,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    required this.price,
    required this.currency,
    required this.date,
    required this.baggage,
    required this.cabinBaggage,
    required this.refundPolicy,
    required this.insuranceIncluded,
  });
}
