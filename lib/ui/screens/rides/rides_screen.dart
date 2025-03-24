import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_7_bla/ui/providers/ride_preferences_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  // RideFilter currentFilter = RideFilter(); TODO: Move to a service class

  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  onRidePrefSelected(RidePreference newPreference) async {}

  void onPreferencePressed(BuildContext context) async {
    RidePreferencesProvider ridePrefsProvider =
        context.read<RidePreferencesProvider>();

    RidePreference currentPreference = ridePrefsProvider.currentPreference!;

    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference
      ridePrefsProvider.setCurrentPreference(newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    RidePreferencesProvider ridePrefsProvider =
        context.watch<RidePreferencesProvider>();

    RidePreference currentRidePreference = ridePrefsProvider.currentPreference!;

    List<Ride> matchingRides =
        RidesService.instance.getRidesFor(currentRidePreference, RideFilter());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentRidePreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
