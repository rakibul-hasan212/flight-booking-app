# flight_booking

A new Flutter project.

# 1. Project Objective

Build a polished Flutter flight-booking application containing these six screens:

1. **Home Screen**
2. **Search Flights Screen**
3. **Flight Details Screen**
4. **Flight Booking Screen**
5. **Payment Confirmation Screen**
6. **E-Ticket Screen**

The primary goal is to demonstrate:

- Flutter UI implementation
- Navigation
- Form handling and validation
- State/data passing between screens
- Reusable widgets
- Responsive layout
- Light/Dark theme support
- Smooth page transitions
- Clean project structure
- Professional UI matching the supplied reference

The application should feel like a small production-quality flight-booking app rather than six unrelated demo screens.

---

# 2. Folder Structure

lib/
├── app/
│   ├── app_routes.dart
│   └── app_theme.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── app_text_field.dart
│       ├── section_title.dart
│       ├── flight_route_widget.dart
│       ├── price_breakdown.dart
│       ├── payment_method_tile.dart
│       └── booking_progress_indicator.dart
├── data/
│   ├── models/
│   │   ├── flight_model.dart
│   │   ├── passenger_model.dart
│   │   └── booking_model.dart
│   └── repositories/
│       ├── flight_repository.dart
│       └── booking_repository.dart
├── features/
│   ├── home/
│   │   └── home_screen.dart
│   ├── search/
│   │   ├── search_flights_screen.dart
│   │   └── search_results_screen.dart
│   ├── flight_details/
│   │   └── flight_details_screen.dart
│   ├── booking/
│   │   ├── flight_booking_screen.dart
│   │   └── payment_confirmation_screen.dart
│   └── ticket/
│       └── e_ticket_screen.dart
└── main.dart

lib/app/app_theme.dart – Custom theme for light and dark modes using Material 3.
lib/app/app_routes.dart – Route generator with named routes and transition animations.
lib/core/constants – Colors, Strings, Sizes constants.
lib/core/widgets – Custom widgets used across the app.
lib/data/models – Data models for Flight, Passenger, and Booking.
lib/data/repositories – Data repository (can be extended for API later).
lib/features/home – Home screen with featured and trending flights.
lib/features/search – Flight search and results.
lib/features/booking – Flight details, booking form, payment screen.
lib/features/ticket – E-ticket display with barcode generation and sharing.

---

# 3. Implementation Process
Following the exact sequence detailed in the spec:

1. Initialize Project: Run flutter create --overwrite . in the directory to initialize the workspace without overwriting the reference files.
2. Configuration & Dependencies: Configure pubspec.yaml with the necessary packages.
3. Data & Models Setup: Define the data models and mock static flights/airports first to prevent hardcoding later.
4. App Theme & Routing: Implement custom AppTheme (Light & Dark mode supporting Material 3) and AppRoutes (handling named routes and smooth route transitions).
5. Feature Screens (One by one, validating navigation and compile status at each step):
    - Home Screen
    - Search Flights Screen
    - Flight Details Screen
    - Flight Booking Screen (Forms & Validation)
    - Payment Confirmation Screen (Voucher & Total calculation)
    - E-Ticket Screen (Barcode generation & Sharing feedback)

---

# 4. Summary of Created Items

1. Initial Project Configuration: Ran flutter create with package name flight_booking
2. Centralized Assets & Colors: Built 
    - app_colors.dart, 
    - app_sizes.dart, and 
    - app_strings.dart
    to define a consistent design system.
3. Data Model Architecture: Implemented models for all structural entities, preventing hardcoding when writing screen components.
4. Mock Data Sets: Created lists of airports and flights inside static data handlers, featuring 6 real-world airports (JFK, CDG, DXB, LHR, DAC, DOH) and 6 detailed flight journeys.
5. App Shell, Routing & Transitions: Configured custom transitions (Slide, Fade, Scale) in 
    - app_routes.dart
    and connected a dynamic ValueNotifier<ThemeMode> in 
    - app.dart
    for quick theme toggling anywhere in the application.

6. Models:
    a. AirportModel in 
    - airport_model.dart
    b. FlightModel in 
    - flight_model.dart
    c. PassengerModel in 
    - passenger_model.dart
    d. BookingModel in 
    - booking_model.dart
    e. SearchCriteria in 
    - search_criteria.dart
    f. OfferModel in 
    - offer_model.dart

7. Static Data:
    a. Airports: Static database in 
    - airport_data.dart
    listing 6 international hubs.
    b. Airlines: Simple dictionary in 
    - airline_data.dart
    mapping airline codes (EK, LH, QR, SQ, TK, DL) to their full names.
    c. Flights: 6 realistic detailed flights in 
    - flight_data.dart
    supporting search routes (such as JFK to CDG), custom bag details, refund policies, and insurance parameters.
    d. Special Offers: Static promotions list in 
    - offer_data.dart
    supporting discount codes (such as VX25 and WELCOME50) for the payment confirmation flow

8. Reusable Widgets Created:

    a. AppButton in 
        - app_button.dart
    — Supports customizable primary/secondary coloring, full-width or custom-width layouts, and prefix icons.
    b. AppCard in 
        - app_card.dart
    — A container matching the rounded visual cards of Task.png that automatically matches the border and background colors depending on Light/Dark theme.
    c. AppTextField in 
    - app_text_field.dart
 — Form text input fields with clean label headers, custom prefix icons, validator handles, and Material 3 border feedback.
    d. SectionTitle in 
    - section_title.dart
 — Standard section title headers with optional right-aligned text buttons.
    e. FlightRouteWidget in 
    flight_route_widget.dart
 — Clean layout rendering departures, arrivals, flight time details, duration, stop indicators, and a center connector line with a rotated airplane icon.
    f. PriceBreakdown in 
    - price_breakdown.dart
 — Calculates and aligns details for Base Fare, Travel Insurance, Tax, and voucher Discount, showing a final calculated bold total.
    g. PaymentMethodTile in 
    - payment_method_tile.dart
 — Selection tile displaying payment methods, icons, and a custom circular selector indicator to bypass deprecations.
    h. BookingProgressIndicator in 
    - booking_progress_indicator.dart
 — Progress line tracking Book ➔ Pay ➔ Done steps using color-coded circular checkmarks.

---


# 5. Dependencies: 
pubspec.yaml
# For QR code generation
qrcode_flutter: ^3.0.0 

# For file operations (saving ticket)
path_provider: ^2.0.15 
# Optional: for sharing ticket
share_plus: ^8.0.0



