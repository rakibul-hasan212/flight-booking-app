import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_booking/app/app.dart';

void main() {
  testWidgets('End-to-End Flight Booking Flow Test', (WidgetTester tester) async {
    // Set standard mobile screen size for testing to prevent layout height limits hit-test failures
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;

    // 1. Launch App (Home Screen)
    await tester.pumpWidget(const FlightBookingApp());
    await tester.pumpAndSettle();

    expect(find.text('Hello, Andrew!'), findsOneWidget);
    expect(find.text('Search Flights'), findsOneWidget);

    // 2. Tap Search Flights button
    await tester.tap(find.text('Search Flights'));
    await tester.pumpAndSettle();

    // Verify Search Flights screen is pushed
    expect(find.text('JFK ➔ CDG'), findsOneWidget);
    expect(find.text('Cheapest first'), findsOneWidget);

    // 3. Select first FlightCard (Emirates)
    await tester.tap(find.text('Emirates'));
    await tester.pumpAndSettle();

    // Verify Flight Details screen is pushed
    expect(find.text('Flight Details'), findsOneWidget);
    expect(find.text('\$1599.00'), findsOneWidget);
    expect(find.text('Cabin Baggage'), findsOneWidget);

    // 4. Tap Continue
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify Flight Booking screen is pushed
    expect(find.text('Book Flight'), findsOneWidget);
    expect(find.text('Passenger Details'), findsOneWidget);

    // Fill in Passenger Form
    await tester.enterText(find.byType(TextFormField).at(0), 'Mr. Andrew Ainsley');
    await tester.enterText(find.byType(TextFormField).at(1), 'andrew@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '+1 111 467 378 399');
    await tester.enterText(find.byType(TextFormField).at(3), 'A12345678');
    await tester.pumpAndSettle();

    // Tap Continue to Payment
    await tester.tap(find.text('Continue to Payment'));
    await tester.pumpAndSettle();

    // Verify Payment Confirmation screen is pushed
    expect(find.text('Payment Confirmation'), findsOneWidget);
    expect(find.text('My Wallet'), findsOneWidget);

    // Enter and apply promo code
    await tester.enterText(find.byType(TextField), 'VX25');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    // Clear SnackBar to prevent it from blocking the Pay Now button hit-test
    final scaffoldMessenger = tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger));
    scaffoldMessenger.clearSnackBars();
    await tester.pumpAndSettle();

    // Tap Pay Now
    await tester.tap(find.text('Pay Now (\$1224.25)'));
    await tester.pumpAndSettle();

    // Verify E-Ticket Screen is pushed
    expect(find.text('E-Ticket'), findsOneWidget);
    expect(find.text('Mr. Andrew Ainsley'), findsOneWidget);
    expect(find.text('Gate'), findsOneWidget);

    // 5. Tap Go to Home to clear stack and reset
    await tester.tap(find.text('Go to Home'));
    await tester.pumpAndSettle();

    // Verify we are back to Home Screen
    expect(find.text('Hello, Andrew!'), findsOneWidget);
  });
}
