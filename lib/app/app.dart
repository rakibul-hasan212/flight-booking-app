import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class FlightBookingApp extends StatefulWidget {
  const FlightBookingApp({super.key});

  // Global static notifier so that any screen can toggle the theme:
  // App.themeModeNotifier.value = ThemeMode.dark / light
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  State<FlightBookingApp> createState() => _FlightBookingAppState();
}

class _FlightBookingAppState extends State<FlightBookingApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: FlightBookingApp.themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'Flight Booking',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentThemeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
