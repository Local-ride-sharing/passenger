import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/driver/single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/location_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/current_location.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/provider/provider_vehicle.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class TrackDriverArrivalMap extends StatefulWidget {
  final Ride ride;

  TrackDriverArrivalMap(this.ride);

  @override
  _TrackDriverArrivalMapState createState() => _TrackDriverArrivalMapState();
}

class _TrackDriverArrivalMapState extends State<TrackDriverArrivalMap> {
  late CurrentLocation currentLocation;
  GoogleMapController? mapController;
  String? mapStyle;
  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? vehicleIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylineSet = {};

  late int lastTheme;

  @override
  void initState() {
    super.initState();

    lastTheme = BlocProvider.of<ThemeCubit>(context).state.value;
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    final Vehicle vehicle = vehicleProvider.get(widget.ride.vehicleReference)!;
    final String vehicleName = vehicle.enName.split(" ").first.toLowerCase();
    DefaultAssetBundle.of(context)
        .loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json')
        .then((string) {
      this.mapStyle = string;
    }).catchError((error) {});
    try {
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), 'images/pickup.png')
          .then((d) {
        pickupMarkerIcon = d;
      });
    } catch (error) {
      pickupMarkerIcon = null;
    }
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

    currentLocation = BlocProvider.of<LocationCubit>(context).state;
    PolylinePoints points = PolylinePoints();
    List<PointLatLng> decodedPolylinePoints = points.decodePolyline(widget.ride.polyline);
    if (decodedPolylinePoints.isNotEmpty) {
      decodedPolylinePoints.forEach((element) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
    }
    final theme = ThemeHelper(lastTheme);

    final Polyline polyline = Polyline(
      polylineId: PolylineId(widget.ride.polyline),
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);

        if (lastTheme != state.value) {
          lastTheme = state.value;
          DefaultAssetBundle.of(context)
              .loadString('assets/map-${theme.isDark ? "dark" : "light"}.json')
              .then((string) {
            this.mapStyle = string;
            if (mapController != null) {
              setState(() {
                this.mapController?.setMapStyle(this.mapStyle);
              });
            }
          }).catchError((error) {});
        }

        return BlocConsumer<SingleDriverCubit, SingleDriverState>(
          listener: (_, state) {
            if (state is SingleDriverSuccess) {
              final Driver driver = state.data;
              setState(() {
                if (mapController != null) {
                  mapController!.animateCamera(CameraUpdate.newLatLngBounds(
                      cameraBounds(
                          widget.ride, driver.location.latitude, driver.location.longitude),
                      42));
                }
              });
            }
          },
          builder: (_, state) {
            if (state is SingleDriverSuccess) {
              final Driver driver = state.data;
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(driver.location.latitude, driver.location.latitude), zoom: 20),
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
                rotateGesturesEnabled: false,
                polylines: polylineSet,
                markers: [
                  Marker(
                    markerId: MarkerId(widget.ride.pickup.label),
                    position: LatLng(widget.ride.pickup.latitude, widget.ride.pickup.longitude),
                    icon: pickupMarkerIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                    anchor: Offset(0.5, 0.5),
                  ),
                  Marker(
                    markerId: MarkerId(driver.reference),
                    position: LatLng(driver.location.latitude, driver.location.longitude),
                    rotation: driver.location.heading,
                    icon: vehicleIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    anchor: Offset(0.5, 0.5),
                  ),
                ].toSet(),
                cameraTargetBounds: CameraTargetBounds(
                    cameraBounds(widget.ride, driver.location.latitude, driver.location.longitude)),
              );
            } else {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 16),
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
        );
      },
    );
  }

  void mapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        this.mapController = controller;
        if (mapStyle != null) {
          this.mapController?.setMapStyle(this.mapStyle);
        }
      });
    }
  }

  LatLngBounds cameraBounds(Ride ride, double lat, double lng) {
    if (ride.pickup.latitude > lat && ride.pickup.longitude > lng) {
      return LatLngBounds(
          southwest: LatLng(lat, lng),
          northeast: LatLng(ride.pickup.latitude, ride.pickup.longitude));
    } else if (ride.pickup.longitude > lng) {
      return LatLngBounds(
          southwest: LatLng(ride.pickup.latitude, lng),
          northeast: LatLng(lat, ride.pickup.longitude));
    } else if (ride.pickup.latitude > lat) {
      return LatLngBounds(
          southwest: LatLng(lat, ride.pickup.longitude),
          northeast: LatLng(ride.pickup.latitude, lng));
    } else {
      return LatLngBounds(
          southwest: LatLng(ride.pickup.latitude, ride.pickup.longitude),
          northeast: LatLng(lat, lng));
    }
  }
}
