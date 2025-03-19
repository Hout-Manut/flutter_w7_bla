import 'package:flutter/material.dart';
import 'package:week_7_bla/model/ride/ride_pref.dart';
import 'package:week_7_bla/repository/ride_preferences_repository.dart';

class RidePreferencesProvider extends ChangeNotifier{
  final RidePreferencesRepository repository;

  RidePreference? _currentPreference;
  late final List<RidePreference> _pastPreferences;

  RidePreferencesProvider(this.repository) {
    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  List<RidePreference> get preferencesHistory => _pastPreferences;

  void setCurrentPreference (RidePreference newPreference) {
    // Returns if the new preference is the same as the current one
    if (newPreference == _currentPreference) return;

    // Update the data
    _currentPreference = newPreference;
    updatePastPreference(newPreference);

    // Notify listeners
    notifyListeners();
  }

  void updatePastPreference(RidePreference newPreference) {
    // Remove it from the list regardless if its in or not
    _pastPreferences.remove(newPreference);

    // Add it to the list
    _pastPreferences.add(newPreference);
  }
}