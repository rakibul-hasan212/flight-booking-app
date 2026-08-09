class SearchCriteria {
  final String from;
  final String to;
  final DateTime departureDate;
  final int passengers;
  final String travelClass;
  final String tripType;

  const SearchCriteria({
    required this.from,
    required this.to,
    required this.departureDate,
    required this.passengers,
    required this.travelClass,
    required this.tripType,
  });
}
