import 'package:week_7_bla/data/dto/location_dto.dart';
import 'package:week_7_bla/model/ride/ride_pref.dart';

class RidePreferenceDto {
  static RidePreference fromJson(Map<String, dynamic> data) {
    return RidePreference(
      departure: LocationDto.fromJson(data['departure']),
      departureDate: DateTime.fromMillisecondsSinceEpoch(data['departureDate']),
      arrival: LocationDto.fromJson(data['arrival']),
      requestedSeats: data['requestedSeats'],
    );
  }

  static Map<String, dynamic> toJson(RidePreference pref) {
    return {
      'departure': LocationDto.toJson(pref.departure),
      'departureDate': pref.departureDate.millisecondsSinceEpoch,
      'arrival': LocationDto.toJson(pref.arrival),
      'requestedSeats': pref.requestedSeats,
    };
  }
}
