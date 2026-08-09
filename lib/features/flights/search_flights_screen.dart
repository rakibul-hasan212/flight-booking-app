import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/widgets/app_button.dart';
import '../../data/static_data/flight_data.dart';
import '../../models/flight_model.dart';
import '../../models/search_criteria.dart';
import 'widgets/flight_card.dart';

class SearchFlightsScreen extends StatefulWidget {
  final SearchCriteria criteria;

  const SearchFlightsScreen({super.key, required this.criteria});

  @override
  State<SearchFlightsScreen> createState() => _SearchFlightsScreenState();
}

class _SearchFlightsScreenState extends State<SearchFlightsScreen> {
  late DateTime _currentSelectedDate;
  String _sortBy = 'price_low'; // 'price_low' or 'price_high'
  String _filterBy = 'all'; // 'all', 'direct', 'stop'

  // Horizontal date selection timeline
  late List<DateTime> _dateTimeline;

  @override
  void initState() {
    super.initState();
    _currentSelectedDate = widget.criteria.departureDate;
    _generateDateTimeline();
  }

  void _generateDateTimeline() {
    // Generate 7 days timeline centered around the selected date
    _dateTimeline = List.generate(7, (index) {
      return _currentSelectedDate.subtract(Duration(days: 3 - index));
    });
  }

  List<FlightModel> _getFilteredAndSortedFlights() {
    // Filter by departure, arrival airport
    var list = FlightData.flights.where((flight) {
      final matchesRoute = flight.departureAirport == widget.criteria.from &&
          flight.arrivalAirport == widget.criteria.to;
      
      if (!matchesRoute) return false;

      // Filter by stops
      if (_filterBy == 'direct') {
        return flight.stops.toLowerCase() == 'direct';
      } else if (_filterBy == 'stop') {
        return flight.stops.toLowerCase() != 'direct';
      }

      return true;
    }).toList();

    // Sort
    if (_sortBy == 'price_low') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_high') {
      list.sort((a, b) => b.price.compareTo(a.price));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final flightsList = _getFilteredAndSortedFlights();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.criteria.from} ➔ ${widget.criteria.to}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.criteria.tripType} • ${widget.criteria.passengers} Passenger${widget.criteria.passengers > 1 ? 's' : ''}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. Horizontal Date Selection Row
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: AppSizes.p8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dateTimeline.length,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              itemBuilder: (context, index) {
                final date = _dateTimeline[index];
                final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                    DateFormat('yyyy-MM-dd').format(_currentSelectedDate);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentSelectedDate = date;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: AppSizes.p8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : (isDark ? theme.colorScheme.secondary : AppColors.primaryBlueLight),
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextPrimary : theme.colorScheme.primary),
                          ),
                        ),
                        Text(
                          DateFormat('E').format(date),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: AppSizes.fontCaption,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.8)
                                : (isDark ? AppColors.darkTextSecondary : theme.colorScheme.primary.withValues(alpha: 0.7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.p8),

          // 2. Sort / Filter Row Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort Dropdown
                Row(
                  children: [
                    const Icon(Icons.sort, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.p4),
                    DropdownButton<String>(
                      value: _sortBy,
                      underline: const SizedBox(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _sortBy = newValue;
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'price_low',
                          child: Text('Cheapest first'),
                        ),
                        DropdownMenuItem(
                          value: 'price_high',
                          child: Text('Expensive first'),
                        ),
                      ],
                    ),
                  ],
                ),

                // Filter Dropdown
                Row(
                  children: [
                    const Icon(Icons.filter_alt_outlined, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.p4),
                    DropdownButton<String>(
                      value: _filterBy,
                      underline: const SizedBox(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _filterBy = newValue;
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('All Stops'),
                        ),
                        DropdownMenuItem(
                          value: 'direct',
                          child: Text('Direct Only'),
                        ),
                        DropdownMenuItem(
                          value: 'stop',
                          child: Text('With Stops'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // 3. Flight List Builder
          Expanded(
            child: flightsList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSizes.p24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flight_land_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: AppSizes.p16),
                        Text(
                          'No Flights Found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p8),
                        Text(
                          'Try changing your route or parameters in search.',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.p24),
                        AppButton(
                          title: 'Modify Search',
                          isFullWidth: false,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    itemCount: flightsList.length,
                    itemBuilder: (context, index) {
                      final flight = flightsList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.p16),
                        child: FlightCard(
                          flight: flight,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.flightDetails,
                              arguments: flight,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
