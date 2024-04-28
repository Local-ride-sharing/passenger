import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/dashboard/instant_ride_cubit.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/ride/direction_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/data/model/current_location.dart';
import 'package:passenger/src/data/model/direction.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/vehicle.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/instant_ride/widget_address_picker.dart';
import 'package:passenger/src/presentation/widget/instant_ride/widget_pricing_panel.dart';
import 'package:passenger/src/presentation/widget/ride_pricing_map/widget_ride_pricing_map.dart';
import 'package:passenger/src/presentation/widget/widget_basic_map.dart';
import 'package:passenger/src/utils/alert_distance_check.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class InstantRideScreen extends StatefulWidget {
  final Address? address;

  @override
  State<InstantRideScreen> createState() => _InstantRideScreenState();

  const InstantRideScreen({
    required this.address,
  });
}

class _InstantRideScreenState extends State<InstantRideScreen> {
  late Passenger profile;

  Address? pickup;
  Address? destination;

  Vehicle? selection;
  Direction? direction;

  @override
  void initState() {
    final CurrentLocation location = BlocProvider.of<LocationCubit>(context).state;
    Helper.findAddress(location.latitude, location.longitude).then((value) {
      if (value != null) {
        setState(() {
          pickup = value;
        });
      }
    });
    if (widget.address != null) {
      destination = widget.address;
    }
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profile = profileProvider.profile!;

    BlocProvider.of<InstantRideVehicleCubit>(context).monitorVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (_, state) {
        final theme = ThemeHelper(state.value);

        return Scaffold(
          backgroundColor: theme.mapBackgroundColor,
          body: Stack(
            children: [
              Positioned(
                child: (pickup != null && destination != null)
                    ? RidePricingMapWidget(
                        pickup: pickup!,
                        destination: destination!,
                        onDirection: (dir) {
                          setState(() {
                            direction = dir;
                          });
                          if (dir.distance < 1.0) {
                            showDialog(context: context, builder: (context) => DirectionDistanceCheckAlert());
                          }
                        },
                      )
                    : BasicMapWidget(),
                top: MediaQuery.of(context).padding.top + 128,
                right: 0,
                left: 0,
                bottom: pickup != null && destination != null ? (selection != null ? 254 : 184) : 0,
              ),
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
                          child: Container(
                            decoration: BoxDecoration(
                                color: theme.errorColor.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AddressPicker(
                                  icon: Icons.hail_rounded,
                                  address: pickup,
                                  hint: "from",
                                  onFinish: (address) {
                                    setState(() {
                                      pickup = address;
                                      if (pickup != null && destination != null) {
                                        BlocProvider.of<DirectionCubit>(context).findDirection(
                                            pickup!.latitude, pickup!.longitude, destination!.latitude, destination!.longitude);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(height: 4),
                                Divider(height: 1, thickness: .4, color: theme.shadowColor),
                                const SizedBox(height: 4),
                                AddressPicker(
                                  icon: Icons.tour_rounded,
                                  address: destination,
                                  hint: "to",
                                  showSavedAddresses: true,
                                  onFinish: (address) {
                                    setState(() {
                                      destination = address;
                                      if (pickup != null && destination != null) {
                                        BlocProvider.of<DirectionCubit>(context).findDirection(
                                            pickup!.latitude, pickup!.longitude, destination!.latitude, destination!.longitude);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
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
                  visible: pickup != null && destination != null,
                  child: pickup != null && destination != null
                      ? direction != null && ((direction?.distance ?? 0) >= 1.0)
                          ? InstantRidePricingPanel(
                              destination: destination!,
                              pickup: pickup!,
                              direction: direction,
                              onSelect: (vehicle) {
                                setState(() {
                                  selection = vehicle;
                                });
                              },
                              vehicle: selection,
                            )
                          : Container()
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
