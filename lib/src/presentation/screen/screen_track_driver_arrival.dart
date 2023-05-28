import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/single_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/presentation/widget/find_driver/widget_ride_information.dart';
import 'package:tmoto_passenger/src/presentation/widget/track_driver_arrival/widget_tracking_map.dart';
import 'package:tmoto_passenger/src/presentation/widget/widget_back_button.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class TrackDriverArrivalScreen extends StatefulWidget {
  final String reference;

  TrackDriverArrivalScreen(this.reference);

  @override
  _TrackDriverArrivalScreenState createState() => _TrackDriverArrivalScreenState();
}

class _TrackDriverArrivalScreenState extends State<TrackDriverArrivalScreen> {
  Ride? ride;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SingleRideCubit>(context).findRide(widget.reference);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: BlocConsumer<SingleRideCubit, SingleRideState>(
            listener: (context, state) {
              if (state is SingleRideSuccess) {
                BlocProvider.of<SingleDriverCubit>(context)
                    .monitorSingleDriver(context, state.data.driverReference ?? "");
                if (state.data.rideCurrentStatus == RideCurrentStatus.arrived) {
                  Navigator.of(context).pushReplacementNamed(AppRouter.rideNavigation,
                      arguments: state.data.reference);
                }
              }
            },
            builder: (_, state) {
              if (state is SingleRideError) {
                return Icon(Icons.error);
              } else if (state is SingleRideNetworking) {
                return CircularProgressIndicator();
              } else if (state is SingleRideSuccess) {
                final Ride ride = state.data;
                return Stack(
                  children: [
                    Positioned(
                        top: 0, right: 0, left: 0, bottom: 130, child: TrackDriverArrivalMap(ride)),
                    Positioned(
                      child: BackButtonWidget(),
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                    ),
                    Positioned(
                      bottom: 88,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: theme.errorColor.withOpacity(.05)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("on the way",
                            style: TextStyles.body(context: context, color: theme.accentColor)),
                      ),
                    ),
                    Align(alignment: Alignment.bottomCenter, child: RideInformation())
                  ],
                );
              } else {
                return Icon(Icons.help);
              }
            },
          ),
        );
      },
    );
  }
}
