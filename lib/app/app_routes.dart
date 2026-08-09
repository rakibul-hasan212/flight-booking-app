import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/flights/search_flights_screen.dart';
import '../features/flight_details/flight_details_screen.dart';
import '../features/booking/flight_booking_screen.dart';
import '../features/payment/payment_confirmation_screen.dart';
import '../features/ticket/e_ticket_screen.dart';
import '../models/search_criteria.dart';
import '../models/flight_model.dart';
import '../models/passenger_model.dart';
import '../models/booking_model.dart';

class AppRoutes {
  static const String home = '/';
  static const String searchFlights = '/search-flights';
  static const String flightDetails = '/flight-details';
  static const String flightBooking = '/flight-booking';
  static const String paymentConfirmation = '/payment-confirmation';
  static const String eTicket = '/e-ticket';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          settings: settings,
        );

      case searchFlights:
        final criteria = settings.arguments as SearchCriteria;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SearchFlightsScreen(criteria: criteria),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          settings: settings,
        );

      case flightDetails:
        final flight = settings.arguments as FlightModel;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => FlightDetailsScreen(flight: flight),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          settings: settings,
        );

      case flightBooking:
        final flight = settings.arguments as FlightModel;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => FlightBookingScreen(flight: flight),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          settings: settings,
        );

      case paymentConfirmation:
        final args = settings.arguments as Map<String, dynamic>;
        final flight = args['flight'] as FlightModel;
        final passenger = args['passenger'] as PassengerModel;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PaymentConfirmationScreen(
            flight: flight,
            passenger: passenger,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          settings: settings,
        );

      case eTicket:
        final booking = settings.arguments as BookingModel;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ETicketScreen(booking: booking),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
