import '../../models/airport_model.dart';

class AirportData {
  static const List<AirportModel> airports = [
    AirportModel(code: 'JFK', city: 'New York', name: 'John F. Kennedy International Airport', country: 'United States'),
    AirportModel(code: 'CDG', city: 'Paris', name: 'Charles de Gaulle Airport', country: 'France'),
    AirportModel(code: 'DXB', city: 'Dubai', name: 'Dubai International Airport', country: 'United Arab Emirates'),
    AirportModel(code: 'LHR', city: 'London', name: 'Heathrow Airport', country: 'United Kingdom'),
    AirportModel(code: 'DAC', city: 'Dhaka', name: 'Hazrat Shahjalal International Airport', country: 'Bangladesh'),
    AirportModel(code: 'DOH', city: 'Doha', name: 'Hamad International Airport', country: 'Qatar'),
  ];
}
