class AirportModel {
  final String code;
  final String city;
  final String name;
  final String country;

  const AirportModel({
    required this.code,
    required this.city,
    required this.name,
    required this.country,
  });

  String get displayName => '$city ($code)';
}
