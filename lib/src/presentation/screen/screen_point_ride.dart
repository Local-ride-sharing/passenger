import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/point/points_cubit.dart';
import 'package:passenger/src/business_logic/ride/create_ride_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/direction.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/point.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/point_ride/pricing/widget_pricing_widget.dart';
import 'package:passenger/src/presentation/widget/point_ride/widget_point_dropdown.dart';
import 'package:passenger/src/presentation/widget/ride_pricing_map/widget_ride_pricing_map.dart';
import 'package:passenger/src/presentation/widget/widget_basic_map.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';
import 'package:uuid/uuid.dart';

class PointRideScreen extends StatefulWidget {
  @override
  _PointRideScreenState createState() => _PointRideScreenState();
}

class _PointRideScreenState extends State<PointRideScreen> {
  Point? selection;
  late Passenger profile;
  Direction? direction;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PointsCubit>(context).monitorPoints();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profile = profileProvider.profile!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);

        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Stack(
            children: [
              Positioned(
                  child: (selection != null)
                      ? RidePricingMapWidget(
                          pickup: selection!.enPickup,
                          destination: selection!.enDestination,
                          onDirection: (dir) {
                            setState(() {
                              direction = dir;
                            });
                          },
                        )
                      : BasicMapWidget(),
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: selection == null ? 0 : 200),
              Positioned(
                child: PhysicalModel(
                  color: theme.backgroundColor,
                  shadowColor: theme.secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back, color: theme.iconColor),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: BlocBuilder<PointsCubit, PointsState>(
                            builder: (_, state) {
                              if (state is PointsError) {
                                return LinearProgressIndicator();
                              } else if (state is PointsNetworking) {
                                return LinearProgressIndicator();
                              } else if (state is PointsSuccess) {
                                final List<Point> points = state.data;
                                return PointDropdown(
                                    value: selection,
                                    text: selection != null
                                        ? "${selection?.enPickup.label} -to- ${selection?.enDestination.label}"
                                        : "Select one",
                                    title: "Select a point",
                                    items: points,
                                    onSelect: (value) {
                                      setState(() {
                                        selection = value;
                                      });
                                    });
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 16,
              ),
              Positioned(
                child: Visibility(
                  visible: selection != null,
                  child: selection != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PointRidePricingWidget(selection!),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: BlocConsumer<CreateRideCubit, CreateRideState>(
                                listener: (_, state) {
                                  if (state is CreateRideSuccess) {
                                    Navigator.of(context).pushReplacementNamed(AppRouter.findDriver, arguments: state.data);
                                  }
                                },
                                builder: (_, state) {
                                  if (state is CreateRideError) {
                                    return Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: theme.textColor),
                                        onPressed: selection != null
                                            ? () {
                                                final Uuid uuid = Uuid();
                                                final Ride ride = Ride(
                                                  reference: uuid.v4(),
                                                  passengerReference: profile.reference,
                                                  pickup: selection!.enPickup,
                                                  destination: selection!.enDestination,
                                                  vehicleReference: selection!.vehicleReference,
                                                  distance: selection!.distance,
                                                  fare: selection!.baseFare,
                                                  polyline: selection!.polyline,
                                                  priority: RidePriority.male,
                                                  duration: selection!.duration,
                                                  rideType: RideType.pointToPoint,
                                                  rideCurrentStatus: RideCurrentStatus.searching,
                                                );
                                                BlocProvider.of<CreateRideCubit>(context).createRide(ride);
                                              }
                                            : null,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Text("Try again",
                                            style: TextStyles.title(context: context, color: theme.backgroundColor)),
                                      ),
                                    );
                                  } else if (state is CreateRideNetworking) {
                                    return Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: theme.backgroundColor),
                                        onPressed: () {},
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Center(
                                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
                                      ),
                                    );
                                  } else if (state is CreateRideSuccess) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: theme.backgroundColor),
                                      onPressed: () {},
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Center(child: Icon(Icons.done_outline_outlined)),
                                    );
                                  } else {
                                    return Container(
                                      margin: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.accentColor,
                                        ),
                                        onPressed: selection != null
                                            ? () {
                                                final Uuid uuid = Uuid();
                                                final Ride ride = Ride(
                                                  reference: uuid.v4(),
                                                  passengerReference: profile.reference,
                                                  pickup: selection!.enPickup,
                                                  destination: selection!.enDestination,
                                                  vehicleReference: selection!.vehicleReference,
                                                  distance: selection!.distance,
                                                  fare: selection!.baseFare,
                                                  polyline: selection!.polyline,
                                                  priority: RidePriority.male,
                                                  duration: selection!.duration,
                                                  rideType: RideType.pointToPoint,
                                                  rideCurrentStatus: RideCurrentStatus.searching,
                                                );
                                                BlocProvider.of<CreateRideCubit>(context).createRide(ride);
                                              }
                                            : null,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Text("Find ride",
                                            style: TextStyles.title(context: context, color: theme.backgroundColor)),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        )
                      : Container(),
                ),
                bottom: 0,
                left: 0,
                right: 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
/*
SizedBox(
width: MediaQuery.of(context).size.width,
child: BlocConsumer<CreateRideCubit, CreateRideState>(
listener: (_, state) {
if (state is CreateRideSuccess) {
Navigator.of(context).pushReplacementNamed(AppRouter.findDriver,
arguments: state.data);
}
},
builder: (_, state) {
if (state is CreateRideError) {
return ElevatedButton(
onPressed: selection != null
? () {
final Uuid uuid = Uuid();
final Ride ride = Ride(
reference: uuid.v4(),
passengerReference: profile.reference,
pickup: selection!.enPickup,
destination: selection!.enDestination,
vehicleReference: selection!.vehicleReference,
distance: selection!.distance,
fare: selection!.baseFare,
polyline: selection!.polyline,
priority: RidePriority.male,
duration: selection!.duration,
rideType: RideType.pointToPoint,
);
BlocProvider.of<CreateRideCubit>(context)
    .createRide(ride);
}
    : null,
clipBehavior: Clip.antiAliasWithSaveLayer,
child: Text("Try again",
style: TextStyles.title(
context: context, color: theme.textColor)),
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
onPressed: selection != null
? () {
final Uuid uuid = Uuid();
final Ride ride = Ride(
reference: uuid.v4(),
passengerReference: profile.reference,
pickup: selection!.enPickup,
destination: selection!.enDestination,
vehicleReference: selection!.vehicleReference,
distance: selection!.distance,
fare: selection!.baseFare,
polyline: selection!.polyline,
priority: RidePriority.male,
duration: selection!.duration,
rideType: RideType.pointToPoint,
);
BlocProvider.of<CreateRideCubit>(context)
    .createRide(ride);
}
    : null,
clipBehavior: Clip.antiAliasWithSaveLayer,
child: Text("Find ride",
style: TextStyles.title(
context: context, color: theme.textColor)),
);
}
},
),
),*/
