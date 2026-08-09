import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/app.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/section_title.dart';
import '../../data/static_data/airport_data.dart';
import '../../data/static_data/offer_data.dart';
import '../../models/airport_model.dart';
import '../../models/search_criteria.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation
  int _currentIndex = 0;

  // Search parameters
  String _selectedTripType = 'One-Way';
  AirportModel? _selectedFrom;
  AirportModel? _selectedTo;
  DateTime? _selectedDate;
  int _passengerCount = 1;
  String _selectedClass = 'Economy';

  @override
  void initState() {
    super.initState();
    // Default selections
    _selectedFrom = AirportData.airports.firstWhere((element) => element.code == 'JFK');
    _selectedTo = AirportData.airports.firstWhere((element) => element.code == 'CDG');
    _selectedDate = DateTime.now().add(const Duration(days: 1)); // Tomorrow
  }

  void _swapFromTo() {
    setState(() {
      final temp = _selectedFrom;
      _selectedFrom = _selectedTo;
      _selectedTo = temp;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAirportSelection(BuildContext context, bool isFrom) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFrom ? 'Select Departure Airport' : 'Select Destination Airport',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.p16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AirportData.airports.length,
                  itemBuilder: (context, index) {
                    final airport = AirportData.airports[index];
                    // Don't show already selected from/to in the opposite selection
                    final isDisabled = isFrom
                        ? airport.code == _selectedTo?.code
                        : airport.code == _selectedFrom?.code;

                    return ListTile(
                      enabled: !isDisabled,
                      leading: const Icon(Icons.local_airport),
                      title: Text('${airport.city} (${airport.code})'),
                      subtitle: Text(airport.name),
                      trailing: Text(
                        airport.country,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            _selectedFrom = airport;
                          } else {
                            _selectedTo = airport;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPassengerAndClassSelector(BuildContext context) {
    final theme = Theme.of(context);
    int tempCount = _passengerCount;
    String tempClass = _selectedClass;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.p20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passengers & Class',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p20),
                  // Passenger Count selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seats / Passengers',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: tempCount > 1
                                ? () {
                                    setModalState(() {
                                      tempCount--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: theme.colorScheme.primary,
                          ),
                          Text(
                            tempCount.toString(),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: tempCount < 9
                                ? () {
                                    setModalState(() {
                                      tempCount++;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: AppSizes.p8),
                  Text(
                    'Cabin Class',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSizes.p12),
                  // Cabin Classes dropdown
                  Wrap(
                    spacing: AppSizes.p8,
                    runSpacing: AppSizes.p8,
                    children: ['Economy', 'Premium Economy', 'Business', 'First Class'].map((className) {
                      final isSelected = tempClass == className;
                      return ChoiceChip(
                        label: Text(className),
                        selected: isSelected,
                        selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (bool selected) {
                          if (selected) {
                            setModalState(() {
                              tempClass = className;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.p24),
                  AppButton(
                    title: 'Apply',
                    onPressed: () {
                      setState(() {
                        _passengerCount = tempCount;
                        _selectedClass = tempClass;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onSearchPressed() {
    if (_selectedFrom == null || _selectedTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both Departure and Destination airports.')),
      );
      return;
    }
    if (_selectedFrom?.code == _selectedTo?.code) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Departure and Destination cannot be the same airport.')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a departure date.')),
      );
      return;
    }

    final criteria = SearchCriteria(
      from: _selectedFrom!.code,
      to: _selectedTo!.code,
      departureDate: _selectedDate!,
      passengers: _passengerCount,
      travelClass: _selectedClass,
      tripType: _selectedTripType,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.searchFlights,
      arguments: criteria,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(AppSizes.r24),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: AppSizes.p20,
                    right: AppSizes.p20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Andrew!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.p4),
                          Text(
                            'Where are you flying today?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      // Profile Avatar with theme toggle callback
                      GestureDetector(
                        onTap: () {
                          // Toggle theme mode dynamically
                          final isCurrentDark = FlightBookingApp.themeModeNotifier.value == ThemeMode.dark;
                          FlightBookingApp.themeModeNotifier.value =
                              isCurrentDark ? ThemeMode.light : ThemeMode.dark;
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Parameters Card (Positioned partly overlapping the header)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 140,
                    left: AppSizes.p20,
                    right: AppSizes.p20,
                  ),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSizes.p20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trip Type Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['One-Way', 'Round Trip', 'Multi-City'].map((type) {
                            final isSelected = _selectedTripType == type;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTripType = type;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.p16,
                                  vertical: AppSizes.p8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : (isDark ? theme.colorScheme.secondary : AppColors.primaryBlueLight),
                                  borderRadius: BorderRadius.circular(AppSizes.r20),
                                ),
                                child: Text(
                                  type,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? AppColors.darkTextPrimary : theme.colorScheme.primary),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSizes.p20),

                        // From Selection Field
                        AppTextField(
                          label: 'From',
                          readOnly: true,
                          prefixIcon: Icons.flight_takeoff,
                          controller: TextEditingController(
                            text: _selectedFrom != null
                                ? '${_selectedFrom!.city} (${_selectedFrom!.code})'
                                : 'Select Airport',
                          ),
                          onTap: () => _showAirportSelection(context, true),
                        ),
                        const SizedBox(height: AppSizes.p12),

                        // Swap Button in between
                        Center(
                          child: InkWell(
                            onTap: _swapFromTo,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.swap_vert,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.p12),

                        // To Selection Field
                        AppTextField(
                          label: 'To',
                          readOnly: true,
                          prefixIcon: Icons.flight_land,
                          controller: TextEditingController(
                            text: _selectedTo != null
                                ? '${_selectedTo!.city} (${_selectedTo!.code})'
                                : 'Select Airport',
                          ),
                          onTap: () => _showAirportSelection(context, false),
                        ),
                        const SizedBox(height: AppSizes.p16),

                        // Date Selector
                        AppTextField(
                          label: 'Departure Date',
                          readOnly: true,
                          prefixIcon: Icons.calendar_today,
                          controller: TextEditingController(
                            text: _selectedDate != null
                                ? DateFormat('EEEE, MMM d yyyy').format(_selectedDate!)
                                : 'Select Date',
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: AppSizes.p16),

                        // Passenger & Class combined Row
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'Passengers',
                                readOnly: true,
                                prefixIcon: Icons.person,
                                controller: TextEditingController(
                                  text: _passengerCount == 1 ? '1 Seat' : '$_passengerCount Seats',
                                ),
                                onTap: () => _showPassengerAndClassSelector(context),
                              ),
                            ),
                            const SizedBox(width: AppSizes.p12),
                            Expanded(
                              child: AppTextField(
                                label: 'Cabin Class',
                                readOnly: true,
                                prefixIcon: Icons.airline_seat_recline_extra,
                                controller: TextEditingController(
                                  text: _selectedClass,
                                ),
                                onTap: () => _showPassengerAndClassSelector(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.p24),

                        // Search Button
                        AppButton(
                          title: 'Search Flights',
                          onPressed: _onSearchPressed,
                          icon: const Icon(Icons.search, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.p24),

            // Special Offers Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
              child: Column(
                children: [
                  const SectionTitle(
                    title: 'Special Offers',
                  ),
                  const SizedBox(height: AppSizes.p12),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: OfferData.offers.length,
                      itemBuilder: (context, index) {
                        final offer = OfferData.offers[index];
                        // Different decorative colors for cards
                        final Color bannerBg = index == 0
                            ? const Color(0xFFFE8C00)
                            : (index == 1 ? const Color(0xFF00B4DB) : const Color(0xFF11998E));

                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: AppSizes.p12),
                          padding: const EdgeInsets.all(AppSizes.p16),
                          decoration: BoxDecoration(
                            color: bannerBg,
                            borderRadius: BorderRadius.circular(AppSizes.r16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offer.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p4),
                                  Text(
                                    offer.description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: AppSizes.fontCaption,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.p8,
                                      vertical: AppSizes.p4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(AppSizes.r8),
                                    ),
                                    child: Text(
                                      'Code: ${offer.discountCode}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppSizes.fontCaption - 1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.p8),
                                  Expanded(
                                    child: Text(
                                      offer.isPercentage
                                          ? '${(offer.discountValue * 100).round()}% OFF'
                                          : '\$${offer.discountValue.round()} OFF',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: AppSizes.fontCaption + 2,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // Spacing at the bottom before bottom nav
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
