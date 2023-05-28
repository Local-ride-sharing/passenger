import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tmoto_passenger/src/business_logic/dashboard/instant_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/create_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/address.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/data/provider/provider_vehicle.dart';
import 'package:tmoto_passenger/src/presentation/widget/instant_ride/widget_vehicle_pricing.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/networking_indicator.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';
import 'package:uuid/uuid.dart';

class InstantRidePricingPanel extends StatefulWidget {
  final Vehicle? vehicle;
  final Address pickup;
  final Address destination;
  final Direction? direction;
  final Function(Vehicle) onSelect;

  const InstantRidePricingPanel(
      {Key? key,
      required this.vehicle,
      required this.direction,
      required this.onSelect,
      required this.pickup,
      required this.destination})
      : super(key: key);

  @override
  _InstantRidePricingPanelState createState() => _InstantRidePricingPanelState();
}

class _InstantRidePricingPanelState extends State<InstantRidePricingPanel> {
  late Passenger profile;
  late RidePriority prioritySelection;

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
      builder: (_, state) {
        final theme = ThemeHelper(state.value);
        return SlidingUpPanel(
          color: theme.backgroundColor,
          panelSnapping: true,
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          minHeight: profile.gender == Gender.female
              ? 342
              : widget.vehicle != null
                  ? 254
                  : 184,
          maxHeight: profile.gender == Gender.female
              ? 342
              : widget.vehicle != null
                  ? 254
                  : 184,
          panel: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 54,
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.shadowColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: profile.gender == Gender.female,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 4),
                  child: Text("Choose gender priority",
                      style: TextStyles.caption(context: context, color: theme.textColor)),
                ),
              ),
              Visibility(
                visible: profile.gender == Gender.female,
                child: Container(
                  padding: EdgeInsets.only(top: 4),
                  alignment: Alignment.center,
                  child: CupertinoSlidingSegmentedControl<RidePriority>(
                    onValueChanged: (priorityType) {
                      if (priorityType != null) {
                        setState(() {
                          prioritySelection = priorityType;
                        });
                      }
                    },
                    children: {
                      RidePriority.female: Text("Female",
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                      RidePriority.femalePriority: Text("Female Priority",
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                      RidePriority.male: Text("Male",
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                    },
                    backgroundColor: theme.secondaryColor,
                    thumbColor: theme.backgroundColor,
                    padding: const EdgeInsets.all(8),
                    groupValue: prioritySelection,
                  ),
                ),
              ),
              Visibility(
                visible: profile.gender == Gender.female,
                child: SizedBox(height: 16),
              ),
              BlocConsumer<InstantRideVehicleCubit, InstantRideVehicleState>(
                listener: (_, state) {
                  if (state is InstantRideVehicleSuccess) {
                    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
                    vehicleProvider.addAll(state.data);
                  }
                },
                builder: (_, state) {
                  if (state is InstantRideVehicleError) {
                    return Icon(Icons.error);
                  } else if (state is InstantRideVehicleNetworking) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is InstantRideVehicleSuccess) {
                    List<Vehicle> vehicles = state.data;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 128,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: vehicles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (BuildContext context, int index) {
                          final Vehicle vehicle = vehicles.elementAt(index);
                          return widget.direction == null
                              ? Center(
                                  child:
                                      NetworkingIndicator(dimension: 20, color: theme.shadowColor))
                              : VehiclePricing(
                                  vehicle: vehicle,
                                  selection: widget.vehicle,
                                  onTap: () {
                                    widget.onSelect(vehicle);
                                  },
                                  destination: widget.destination,
                                  pickup: widget.pickup,
                                  direction: widget.direction!,
                                );
                        },
                      ),
                    );
                  } else {
                    return Icon(Icons.help);
                  }
                },
              ),
              Visibility(
                visible: widget.vehicle != null,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(16),
                  child: BlocConsumer<CreateRideCubit, CreateRideState>(
                    listener: (_, state) {
                      if (state is CreateRideSuccess) {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRouter.findDriver, arguments: state.data);
                      }
                    },
                    builder: (_, state) {
                      if (state is CreateRideError) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: theme.accentColor,
                          ),
                          onPressed: () {
                            if (widget.vehicle != null && widget.direction != null) {
                              final int fare = (widget.vehicle!.baseFare +
                                      (widget.vehicle!.perKmFare * widget.direction!.distance) +
                                      (widget.vehicle!.perMinuteFare * widget.direction!.duration))
                                  .ceilToDouble()
                                  .toInt();
                              final Uuid uuid = Uuid();
                              final Ride ride = Ride(
                                reference: uuid.v4(),
                                passengerReference: profile.reference,
                                pickup: widget.pickup,
                                destination: widget.destination,
                                vehicleReference: widget.vehicle!.reference,
                                distance: widget.direction!.distance,
                                fare: fare,
                                polyline: widget.direction!.polyline,
                                priority: prioritySelection,
                                duration: widget.direction!.duration,
                                rideType: RideType.instantRide,
                                rideCurrentStatus: RideCurrentStatus.searching,
                              );
                              BlocProvider.of<CreateRideCubit>(context).createRide(ride);
                            }
                          },
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Text("Try again",
                              style: TextStyles.title(context: context, color: theme.textColor)),
                        );
                      } else if (state is CreateRideNetworking) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: theme.accentColor,
                          ),
                          onPressed: () {},
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: NetworkingIndicator(dimension: 20, color: theme.backgroundColor),
                        );
                      } else if (state is CreateRideSuccess) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: theme.accentColor,
                          ),
                          onPressed: () {},
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Center(child: Icon(Icons.done_outline_outlined)),
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: theme.accentColor,
                          ),
                          onPressed: () {
                            if (widget.vehicle != null && widget.direction != null) {
                              final int fare = (widget.vehicle!.baseFare +
                                      (widget.vehicle!.perKmFare * widget.direction!.distance) +
                                      (widget.vehicle!.perMinuteFare * widget.direction!.duration))
                                  .ceilToDouble()
                                  .toInt();
                              final Uuid uuid = Uuid();
                              final Ride ride = Ride(
                                reference: uuid.v4(),
                                passengerReference: profile.reference,
                                pickup: widget.pickup,
                                destination: widget.destination,
                                vehicleReference: widget.vehicle!.reference,
                                distance: widget.direction!.distance,
                                fare: fare,
                                polyline: widget.direction!.polyline,
                                priority: prioritySelection,
                                duration: widget.direction!.duration,
                                rideType: RideType.instantRide,
                                rideCurrentStatus: RideCurrentStatus.searching,
                              );
                              BlocProvider.of<CreateRideCubit>(context).createRide(ride);
                            }
                          },
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Text("Find ride",
                              style: TextStyles.title(context: context, color: Colors.white)),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
