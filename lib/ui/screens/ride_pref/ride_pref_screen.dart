import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_7_bla/ui/providers/async_value_provider.dart';
import 'package:week_7_bla/ui/providers/ride_preferences_provider.dart';
import 'package:week_7_bla/ui/widgets/display/bla_error.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    RidePreferencesProvider ridePrefsProvider =
        context.read<RidePreferencesProvider>();

    // 1 - Update the current preference
    ridePrefsProvider.setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  Widget _buildPastPrefsList(BuildContext context) {
    RidePreferencesProvider ridePrefsProvider =
        context.read<RidePreferencesProvider>();
    AsyncValue<List<RidePreference>> value = ridePrefsProvider.pastPreferences;
    switch (value.state) {
      case AsyncValueState.loading:
        return BlaError(
          'Loading...',
          level: BlaErrorLevel.info,
        );
      case AsyncValueState.error:
        return BlaError('Error fetching past ride preferences',
            level: BlaErrorLevel.error);
      case AsyncValueState.success:
        return SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: value.data!.length,
            itemBuilder: (ctx, index) => RidePrefHistoryTile(
              ridePref: value.data![index],
              onPressed: () => onRidePrefSelected(context, value.data![index]),
            ),
          ),
        );
      case AsyncValueState.empty:
        return BlaError(
          'No past ride preferences.',
          level: BlaErrorLevel.info,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    RidePreferencesProvider ridePrefsProvider =
        context.watch<RidePreferencesProvider>();

    RidePreference? currentRidePreference = ridePrefsProvider.currentPreference;
    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (newPref) =>
                          onRidePrefSelected(context, newPref)),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  _buildPastPrefsList(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
