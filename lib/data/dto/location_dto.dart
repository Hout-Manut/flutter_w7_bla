import 'package:week_7_bla/model/location/locations.dart';

class LocationDto {
  static Location fromJson(Map<String, dynamic> data) {
    return Location(
      name: data['name'],
      country: countryFromString(data['country']),
    );
  }

  static Map<String, dynamic> toJson(Location location) {
    return {
      'name': location.name,
      'country': location.country.name,
    };
  }

  static Country countryFromString(String value) {
    return Country.values.firstWhere(
      (c) => c.name == value,
      orElse: () => throw ArgumentError('Invalid country: $value'),
    );
  }
}
