import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/ride/create_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';
import 'package:uuid/uuid.dart';

class NoDriverFound extends StatefulWidget {
  final Ride ride;

  NoDriverFound(this.ride);

  @override
  State<NoDriverFound> createState() => _NoDriverFoundState();
}

class _NoDriverFoundState extends State<NoDriverFound> {
  String selection = "";
  String polyLine = "";
  int rideFare = -1;
  int rideDuration = -1;
  double rideDistance = -1;
  late RidePriority prioritySelection;
  late Passenger profile;

  @override
  void initState() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profile = profileProvider.profile!;
    prioritySelection =
        profile.gender == Gender.female ? RidePriority.femalePriority : RidePriority.male;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return PhysicalModel(
          color: theme.backgroundColor,
          shadowColor: theme.secondaryColor,
          elevation: 8,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning_rounded, color: theme.errorColor, size: 54),
                SizedBox(height: 8),
                Text("No driver found",
                    style: TextStyles.caption(context: context, color: theme.errorColor)),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: BlocConsumer<CreateRideCubit, CreateRideState>(
                    listener: (_, state) {
                      if (state is CreateRideSuccess) {
                        widget.ride.reference = state.data.reference;
                        Navigator.of(context)
                            .pushReplacementNamed(AppRouter.findDriver, arguments: widget.ride);
                      }
                    },
                    builder: (_, state) {
                      if (state is CreateRideError) {
                        return ElevatedButton(
                          onPressed: () {
                            if (selection.isNotEmpty &&
                                polyLine.isNotEmpty &&
                                !rideFare.isNegative &&
                                !rideDuration.isNegative &&
                                !rideDistance.isNegative) {
                              final Uuid uuid = Uuid();
                              widget.ride.reference = uuid.v4();
                              widget.ride.vehicleReference = selection;
                              widget.ride.polyline = polyLine;
                              widget.ride.fare = rideFare;
                              widget.ride.distance = rideDistance;
                              widget.ride.duration = rideDuration;
                              widget.ride.priority = prioritySelection;
                              widget.ride.rideType = RideType.instantRide;
                              BlocProvider.of<CreateRideCubit>(context).createRide(widget.ride);
                            }
                          },
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Text("Oops try again",
                              style: TextStyles.title(context: context, color: theme.textColor)),
                        );
                      } else if (state is CreateRideNetworking) {
                        return ElevatedButton(
                          onPressed: () {},
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.blue))),
                        );
                      } else if (state is CreateRideSuccess) {
                        return ElevatedButton(
                          onPressed: () {},
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Center(child: Icon(Icons.done_outline_outlined)),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            if (selection.isNotEmpty &&
                                polyLine.isNotEmpty &&
                                !rideFare.isNegative &&
                                !rideDuration.isNegative &&
                                !rideDistance.isNegative) {
                              final Uuid uuid = Uuid();
                              widget.ride.reference = uuid.v4();
                              widget.ride.vehicleReference = selection;
                              widget.ride.polyline = polyLine;
                              widget.ride.fare = rideFare;
                              widget.ride.distance = rideDistance;
                              widget.ride.duration = rideDuration;
                              widget.ride.priority = prioritySelection;
                              widget.ride.rideType = RideType.instantRide;
                              BlocProvider.of<CreateRideCubit>(context).createRide(widget.ride);
                            }
                          },
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Text("Try again",
                              style: TextStyles.title(context: context, color: theme.textColor)),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
