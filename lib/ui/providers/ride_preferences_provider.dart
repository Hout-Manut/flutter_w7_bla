import 'package:flutter/material.dart';
import 'package:week_7_bla/model/ride/ride_pref.dart';
import 'package:week_7_bla/ui/providers/async_value_provider.dart';
import 'package:week_7_bla/data/repository/ride_preferences_repository.dart';

class RidePreferencesProvider extends ChangeNotifier {
  final RidePreferencesRepository repository;

  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> _pastPreferences;

  RidePreferencesProvider(this.repository) {
    fetchPastPreference();
  }

  void fetchPastPreference() async {
    _pastPreferences = AsyncValue.loading();

    notifyListeners();

    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences();

      if (pastPrefs.isEmpty) {
        _pastPreferences = AsyncValue.empty();
      } else {
        _pastPreferences = AsyncValue.success(pastPrefs);
      }
    } catch (error) {
      _pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  RidePreference? get currentPreference => _currentPreference;

  AsyncValue<List<RidePreference>> get pastPreferences => _pastPreferences;

  void setCurrentPreference(RidePreference newPreference) {
    // Returns if the new preference is the same as the current one
    if (newPreference == _currentPreference) return;

    // Update the data
    _currentPreference = newPreference;
    updatePastPreference(newPreference);
  }

  void updatePastPreference(RidePreference newPreference) async {
    await repository.addPreference(newPreference);

    // I decided to fetch the data again, because the data in the repository might get changed
    // from somewhere else and doing so will update the data to the latest.
    fetchPastPreference();
  }
}
