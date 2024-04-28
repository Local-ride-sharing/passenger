import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/driver/single_driver_cubit.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/ride/single_ride_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/current_location.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/model/vehicle.dart';
import 'package:passenger/src/data/provider/provider_vehicle.dart';
import 'package:passenger/src/presentation/widget/find_driver/widget_ride_information.dart';
import 'package:passenger/src/presentation/widget/widget_back_button.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class RideNavigationScreen extends StatefulWidget {
  final String reference;

  RideNavigationScreen(this.reference);

  @override
  _RideNavigationScreenState createState() => _RideNavigationScreenState();
}

class _RideNavigationScreenState extends State<RideNavigationScreen> {
  GoogleMapController? mapController;
  String? mapStyle;
  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? destinationMarkerIcon;
  BitmapDescriptor? vehicleIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylineSet = {};

  late int lastTheme;
  late CurrentLocation currentLocation;
  Ride? ride;

  @override
  void initState() {
    lastTheme = BlocProvider.of<ThemeCubit>(context).state.value;
    currentLocation = BlocProvider.of<LocationCubit>(context).state;
    BlocProvider.of<SingleRideCubit>(context).findRide(widget.reference);
    try {
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), 'images/pickup.png').then((d) {
        pickupMarkerIcon = d;
      });
    } catch (error) {
      pickupMarkerIcon = null;
    }
    try {
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), 'images/destination.png').then((d) {
        destinationMarkerIcon = d;
      });
    } catch (error) {
      destinationMarkerIcon = null;
    }

    DefaultAssetBundle.of(context)
        .loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json')
        .then((string) {
      this.mapStyle = string;
    }).catchError((error) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);

        if (lastTheme != state.value) {
          lastTheme = state.value;
          DefaultAssetBundle.of(context).loadString('assets/map-${theme.isDark ? "dark" : "light"}.json').then((string) {
            this.mapStyle = string;
            if (mapController != null) {
              setState(() {
                this.mapController?.setMapStyle(this.mapStyle);
              });
            }
          }).catchError((error) {});
        }
        return Scaffold(
          body: BlocConsumer<SingleRideCubit, SingleRideState>(
            listener: (_, state) {
              if (state is SingleRideSuccess) {
                final Ride ride = state.data;
                BlocProvider.of<SingleDriverCubit>(context).monitorSingleDriver(context, ride.driverReference ?? "");

                final Vehicle vehicle = vehicleProvider.get(ride.vehicleReference)!;
                final String vehicleName = vehicle.enName.split(" ").first.toLowerCase();
                try {
                  BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size.fromHeight(92)), 'images/$vehicleName-marker.png')
                      .then((d) {
                    setState(() {
                      vehicleIcon = d;
                    });
                  });
                } catch (error) {
                  vehicleIcon = null;
                }
                PolylinePoints points = PolylinePoints();
                List<PointLatLng> decodedPolylinePoints = points.decodePolyline(ride.polyline);
                if (decodedPolylinePoints.isNotEmpty) {
                  decodedPolylinePoints.forEach((element) {
                    polylineCoordinates.add(LatLng(element.latitude, element.longitude));
                  });
                }

                final Polyline polyline = Polyline(
                  polylineId: PolylineId(ride.polyline),
                  color: theme.primaryColor,
                  jointType: JointType.round,
                  points: polylineCoordinates,
                  width: 4,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  geodesic: true,
                );

                setState(() {
                  polylineSet.add(polyline);
                });

                if (state.data.rideCurrentStatus == RideCurrentStatus.finished) {
                  Navigator.of(context).pushReplacementNamed(AppRouter.finishRide, arguments: state.data.reference);
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
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 130,
                      child: BlocConsumer<SingleDriverCubit, SingleDriverState>(
                        listener: (_, state) {
                          if (state is SingleDriverSuccess) {
                            final Driver driver = state.data;
                            setState(() {
                              if (mapController != null) {
                                mapController?.animateCamera(CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(driver.location.latitude, driver.location.longitude),
                                    zoom: 18.5,
                                    bearing: driver.location.heading,
                                  ),
                                ));
                              }
                            });
                          }
                        },
                        builder: (_, state) {
                          if (state is SingleDriverSuccess) {
                            final Driver driver = state.data;
                            return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(driver.location.latitude, driver.location.longitude),
                                bearing: driver.location.heading,
                                zoom: 18.5,
                              ),
                              mapType: MapType.normal,
                              indoorViewEnabled: false,
                              onMapCreated: mapCreated,
                              mapToolbarEnabled: false,
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              trafficEnabled: false,
                              compassEnabled: false,
                              buildingsEnabled: true,
                              rotateGesturesEnabled: true,
                              polylines: polylineSet,
                              onTap: (loc) {
                                setState(() {
                                  mapController?.animateCamera(CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(driver.location.latitude, driver.location.longitude),
                                      zoom: 18.5,
                                      bearing: driver.location.heading,
                                    ),
                                  ));
                                });
                              },
                              markers: [
                                Marker(
                                  markerId: MarkerId(ride.pickup.label),
                                  position: LatLng(ride.pickup.latitude, ride.pickup.longitude),
                                  icon: pickupMarkerIcon ?? BitmapDescriptor.defaultMarker,
                                ),
                                Marker(
                                  markerId: MarkerId(ride.destination.label),
                                  position: LatLng(ride.destination.latitude, ride.destination.longitude),
                                  icon: destinationMarkerIcon ?? BitmapDescriptor.defaultMarker,
                                ),
                                Marker(
                                  markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
                                  position: LatLng(driver.location.latitude, driver.location.longitude),
                                  anchor: Offset(0.5, 0.5),
                                  icon: vehicleIcon ?? BitmapDescriptor.defaultMarker,
                                ),
                              ].toSet(),
                            );
                          } else {
                            return GoogleMap(
                              initialCameraPosition:
                                  CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 16),
                              mapType: MapType.normal,
                              indoorViewEnabled: false,
                              onMapCreated: mapCreated,
                              mapToolbarEnabled: false,
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              trafficEnabled: true,
                              compassEnabled: false,
                              buildingsEnabled: true,
                              rotateGesturesEnabled: false,
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      child: BackButtonWidget(),
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                    ),
                    Positioned(
                      bottom: 90,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(16), color: theme.errorColor.withOpacity(.06)),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Driver will start the ride please wait...",
                            style: TextStyles.caption(context: context, color: theme.textColor)),
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

  void mapCreated(GoogleMapController controller) {
    setState(() {
      this.mapController = controller;
      if (mapStyle != null) {
        this.mapController?.setMapStyle(this.mapStyle);
      }
    });
  }
}
