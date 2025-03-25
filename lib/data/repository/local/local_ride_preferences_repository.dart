import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_7_bla/data/dto/ride_preference_dto.dart';
import 'package:week_7_bla/data/repository/ride_preferences_repository.dart';
import 'package:week_7_bla/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferenceKey = 'ride_preferences';

  @override
  Future<void> addPreference(RidePreference preference) async {
    List<RidePreference> pastPrefs = await getPastPreferences();
    pastPrefs.remove(preference);
    pastPrefs.add(preference);
    List<String> json = pastPrefs.map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
        .toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_preferenceKey, json);
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList(_preferenceKey) ?? [];

    return data
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }
}
