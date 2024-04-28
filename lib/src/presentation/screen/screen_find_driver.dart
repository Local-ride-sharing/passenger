import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/ride/create_ride_cubit.dart';
import 'package:passenger/src/business_logic/ride/find_driver_cubit.dart';
import 'package:passenger/src/business_logic/ride/single_ride_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/current_location.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/model/vehicle.dart';
import 'package:passenger/src/data/provider/provider_vehicle.dart';
import 'package:passenger/src/presentation/inherited/inherited_ride.dart';
import 'package:passenger/src/presentation/widget/find_driver/widget_driver.dart';
import 'package:passenger/src/presentation/widget/find_driver/widget_networking.dart';
import 'package:passenger/src/presentation/widget/find_driver/widget_no_driver.dart';
import 'package:passenger/src/presentation/widget/widget_back_button_find_driver.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class FindDriverScreen extends StatefulWidget {
  @override
  _FindDriverScreenState createState() => _FindDriverScreenState();
}

class _FindDriverScreenState extends State<FindDriverScreen> {
  LatLng? currentLocation;
  GoogleMapController? mapController;
  String? mapStyle;

  late int lastTheme;

  List<Driver> drivers = [];
  late Ride ride;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylineSet = {};
  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? destinationMarkerIcon;

  var future;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationCubit>(context).track();

    lastTheme = BlocProvider.of<ThemeCubit>(context).state.value;

    final CurrentLocation location = BlocProvider.of<LocationCubit>(context).state;
    currentLocation = LatLng(location.latitude, location.longitude);

    Future.delayed(
      Duration.zero,
      () {
        try {
          ride = InheritedRide.of(context).ride;
          BlocProvider.of<SingleRideCubit>(context).findRide(ride.reference);
          final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
          final Vehicle vehicle = vehicleProvider.get(ride.vehicleReference)!;
          BlocProvider.of<FindDriverCubit>(context).findDrivers(ride, vehicle);

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
          PolylinePoints points = PolylinePoints();
          List<PointLatLng> decodedPolylinePoints = points.decodePolyline(ride.polyline);
          if (decodedPolylinePoints.isNotEmpty) {
            decodedPolylinePoints.forEach((element) {
              polylineCoordinates.add(LatLng(element.latitude, element.longitude));
            });
          }
          final theme = ThemeHelper(lastTheme);

          final Polyline polyline = Polyline(
            polylineId: PolylineId(ride.polyline),
            color: theme.accentColor,
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
        } catch (error) {
          print(error);
        }
      },
    );

    DefaultAssetBundle.of(context)
        .loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json')
        .then((string) {
      this.mapStyle = string;
    }).catchError((error) {});

    FirebaseMessaging.onMessage.listen((message) {
      Map<String, dynamic> data = message.data;
      if (data["category"] == "ride-rejected") {
        setState(() {
          drivers.removeAt(0);
        });
        if (drivers.isNotEmpty) {
          final Ride ride = InheritedRide.of(context).ride;
          final Driver driver = drivers.first;
          Helper().publishRideRequestNotification(ride, driver);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Map<String, dynamic> data = message.data;
      if (data["category"] == "ride-rejected") {
        setState(() {
          drivers.removeAt(0);
        });
        if (drivers.isNotEmpty) {
          final Ride ride = InheritedRide.of(context).ride;
          final Driver driver = drivers.first;
          Helper().publishRideRequestNotification(ride, driver);
        }
      }
    });

    future = _future();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (_, state) {
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
        return FutureBuilder(
          future: future,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BlocListener<SingleRideCubit, SingleRideState>(
                listener: (context, state) {
                  if (state is SingleRideSuccess) {
                    if (state.data.rideCurrentStatus == RideCurrentStatus.accepted) {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRouter.driverArrivalTracking, arguments: state.data.reference);
                    }
                  }
                },
                child: Scaffold(
                  backgroundColor: theme.backgroundColor,
                  body: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 166,
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: LatLng(ride.destination.latitude, ride.destination.longitude), zoom: 16),
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
                          polylines: polylineSet,
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
                          ].toSet(),
                          onTap: (loc) {
                            final List<double> latitudes = polylineCoordinates.map((e) => e.latitude).toList();
                            final List<double> longitudes = polylineCoordinates.map((e) => e.longitude).toList();

                            latitudes.sort((a, b) => a.compareTo(b));

                            longitudes.sort((a, b) => a.compareTo(b));

                            double yMin = longitudes.first;
                            double yMax = longitudes.last;
                            double xMin = latitudes.first;
                            double xMax = latitudes.last;

                            LatLngBounds bounds = LatLngBounds(
                              northeast: LatLng(xMax, yMax),
                              southwest: LatLng(xMin, yMin),
                            );
                            Future.delayed(Duration(milliseconds: 1), () {
                              setState(() {
                                mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 54));
                              });
                            });
                          },
                        ),
                      ),
                      Positioned(
                        child: BlocConsumer<FindDriverCubit, FindDriverState>(
                          listener: (_, state) {
                            if (state is FindDriverSuccess) {
                              drivers = state.data;
                              setState(() {});
                              if (drivers.isNotEmpty) {
                                final Ride ride = InheritedRide.of(context).ride;
                                final Driver driver = drivers.first;
                                Helper().publishRideRequestNotification(ride, driver);
                              }
                            }
                          },
                          builder: (_, state) {
                            if (state is FindDriverError) {
                              return Text(state.error, style: TextStyles.body(context: context, color: theme.errorColor));
                            } else if (state is FindDriverNetworking) {
                              return FindDriverNetworkingWidget();
                            } else if (state is FindDriverSuccess) {
                              return drivers.isEmpty
                                  ? BlocProvider(
                                      create: (context) => CreateRideCubit(),
                                      child: BlocProvider(
                                        create: (context) => CreateRideCubit(),
                                        child: NoDriverFound(ride),
                                      ),
                                    )
                                  : FindDriverCurrentAssignedDriver(driver: drivers.first);
                            } else {
                              return Icon(Icons.help);
                            }
                          },
                        ),
                        bottom: 0,
                        left: 0,
                        right: 0,
                      ),
                      Positioned(
                        child: BackButtonFindDriverWidget(ride),
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(backgroundColor: theme.backgroundColor);
            }
          },
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

      final List<double> latitudes = polylineCoordinates.map((e) => e.latitude).toList();
      final List<double> longitudes = polylineCoordinates.map((e) => e.longitude).toList();

      latitudes.sort((a, b) => a.compareTo(b));

      longitudes.sort((a, b) => a.compareTo(b));

      double yMin = longitudes.first;
      double yMax = longitudes.last;
      double xMin = latitudes.first;
      double xMax = latitudes.last;

      LatLngBounds bounds = LatLngBounds(
        northeast: LatLng(xMax, yMax),
        southwest: LatLng(xMin, yMin),
      );
      Future.delayed(Duration(milliseconds: 1), () {
        setState(() {
          mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 54));
        });
      });
    });
  }

  _future() => Future.delayed(Duration(milliseconds: 1));
}
