import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_7_bla/data/dto/ride_preference_dto.dart';
import 'package:week_7_bla/data/repository/ride_preferences_repository.dart';
import 'package:week_7_bla/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferenceKey = 'ride_preferences';

  List<RidePreference> _pastPreferencesCache = [];

  LocalRidePreferencesRepository() {
    _loadLocalPastPreferences();
  }

  void _loadLocalPastPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList(_preferenceKey) ?? [];

    _pastPreferencesCache = data
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    _pastPreferencesCache.remove(preference);
    _pastPreferencesCache.insert(0, preference);
    List<String> json = _pastPreferencesCache
        .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
        .toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_preferenceKey, json);
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    return _pastPreferencesCache;
  }
}
