import '../location/locations.dart';

///
/// This model describes a ride preference.
/// A ride preference consists of the selection of a departure + arrival + a date and a number of passenger
///
class RidePreference {
  final Location departure;
  final DateTime departureDate;
  final Location arrival;
  final int requestedSeats;

  const RidePreference(
      {required this.departure,
      required this.departureDate,
      required this.arrival,
      required this.requestedSeats});

  @override
  String toString() {
    return 'RidePref(departure: ${departure.name}, '
        'departureDate: ${departureDate.toIso8601String()}, '
        'arrival: ${arrival.name}, '
        'requestedSeats: $requestedSeats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RidePreference) return false;

    bool sameDay;
    DateTime now = DateTime.now();

    if (departureDate.isBefore(now) && other.departureDate.isBefore(now)) {
      // Consider past ride preferences as today
      sameDay = true;
    } else {
      sameDay = departureDate == other.departureDate;
    }

    // Requested seats are not checked because the actual app acts like so.
    return other.arrival == arrival && other.departure == departure && sameDay;
  }

  @override
  int get hashCode =>
      arrival.hashCode ^ departure.hashCode ^ departureDate.hashCode;
}
