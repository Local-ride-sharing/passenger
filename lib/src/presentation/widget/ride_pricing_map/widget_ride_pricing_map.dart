import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/src/business_logic/ride/direction_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/data/model/direction.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class RidePricingMapWidget extends StatefulWidget {
  final Address pickup;
  final Address destination;
  final Function(Direction) onDirection;

  RidePricingMapWidget({required this.pickup, required this.destination, required this.onDirection});

  @override
  _RidePricingMapWidgetState createState() => _RidePricingMapWidgetState();
}

class _RidePricingMapWidgetState extends State<RidePricingMapWidget> {
  GoogleMapController? mapController;
  String? mapStyle;
  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? destinationMarkerIcon;

  late int lastTheme;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylineSet = {};

  @override
  void initState() {
    super.initState();
    lastTheme = BlocProvider.of<ThemeCubit>(context).state.value;

    DefaultAssetBundle.of(context)
        .loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json')
        .then((string) {
      this.mapStyle = string;
    }).catchError((error) {});

    Future.delayed(
      Duration(milliseconds: 1),
      () {
        BlocProvider.of<DirectionCubit>(context).findDirection(
          widget.pickup.latitude,
          widget.pickup.longitude,
          widget.destination.latitude,
          widget.destination.longitude,
        );
      },
    );
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
  }

  @override
  Widget build(BuildContext context) {
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
        return BlocConsumer<DirectionCubit, DirectionState>(
          listener: (_, state) {
            if (state is DirectionSuccess) {
              final Direction direction = state.data;
              widget.onDirection(direction);
              PolylinePoints points = PolylinePoints();
              List<PointLatLng> decodedPolylinePoints = points.decodePolyline(direction.polyline);
              polylineCoordinates = [];
              if (decodedPolylinePoints.isNotEmpty) {
                decodedPolylinePoints.forEach((element) {
                  polylineCoordinates.add(LatLng(element.latitude, element.longitude));
                });
              }

              Polyline polyline = Polyline(
                polylineId: PolylineId(direction.polyline),
                color: theme.accentColor,
                jointType: JointType.round,
                points: polylineCoordinates,
                width: 4,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                geodesic: true,
              );

              final List<double> latitudes = polylineCoordinates.map((e) => e.latitude).toList();
              final List<double> longitudes = polylineCoordinates.map((e) => e.longitude).toList();

              latitudes.add(widget.pickup.latitude);
              latitudes.add(widget.destination.latitude);
              longitudes.add(widget.pickup.longitude);
              longitudes.add(widget.destination.longitude);

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
              polylineSet = {};
              setState(() {
                polylineSet.add(polyline);
                mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 54));
              });
            }
          },
          builder: (_, state) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(widget.destination.latitude, widget.destination.longitude), zoom: 16),
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
                  onTap: (loc) {
                    final List<double> latitudes = polylineCoordinates.map((e) => e.latitude).toList();
                    final List<double> longitudes = polylineCoordinates.map((e) => e.longitude).toList();

                    latitudes.add(widget.pickup.latitude);
                    latitudes.add(widget.destination.latitude);
                    longitudes.add(widget.pickup.longitude);
                    longitudes.add(widget.destination.longitude);

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
                    setState(() {
                      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 54));
                    });
                  },
                  markers: [
                    Marker(
                      markerId: MarkerId(widget.pickup.label),
                      position: LatLng(widget.pickup.latitude, widget.pickup.longitude),
                      icon: pickupMarkerIcon ?? BitmapDescriptor.defaultMarker,
                    ),
                    Marker(
                      markerId: MarkerId(widget.destination.label),
                      position: LatLng(widget.destination.latitude, widget.destination.longitude),
                      icon: destinationMarkerIcon ?? BitmapDescriptor.defaultMarker,
                    ),
                  ].toSet(),
                ),
                Visibility(
                  visible: state is DirectionNetworking,
                  child: Container(
                    decoration: BoxDecoration(color: theme.shadowColor),
                    child: Center(child: CircularProgressIndicator(color: theme.textColor)),
                  ),
                ),
              ],
            );
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
    });
    Future.delayed(Duration(milliseconds: 100), () {
      final List<double> latitudes = polylineCoordinates.map((e) => e.latitude).toList();
      final List<double> longitudes = polylineCoordinates.map((e) => e.longitude).toList();

      latitudes.add(widget.pickup.latitude);
      latitudes.add(widget.destination.latitude);
      longitudes.add(widget.pickup.longitude);
      longitudes.add(widget.destination.longitude);

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
      setState(() {
        mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 54));
      });
    });
  }
}
