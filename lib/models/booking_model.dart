import 'flight_model.dart';
import 'passenger_model.dart';

class BookingModel {
  final String bookingId;
  final FlightModel flight;
  final PassengerModel passenger;
  final String seatNumber;
  final double baseFare;
  final double tax;
  final double discount;
  final double totalAmount;
  final String paymentMethod;
  final String flightNumber;
  final String gate;

  const BookingModel({
    required this.bookingId,
    required this.flight,
    required this.passenger,
    required this.seatNumber,
    required this.baseFare,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.flightNumber,
    required this.gate,
  });
}
