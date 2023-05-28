import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/point.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class RidePricingDirectionMapWidget extends StatefulWidget {
  final Point point;

  RidePricingDirectionMapWidget(this.point);

  @override
  _RidePricingDirectionMapWidgetState createState() => _RidePricingDirectionMapWidgetState();
}

class _RidePricingDirectionMapWidgetState extends State<RidePricingDirectionMapWidget> {
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

    DefaultAssetBundle.of(context).loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json').then((string) {
      this.mapStyle = string;
    }).catchError((error) {});

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
    List<PointLatLng> decodedPolylinePoints = points.decodePolyline(widget.point.polyline);
    if (decodedPolylinePoints.isNotEmpty) {
      decodedPolylinePoints.forEach((element) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
    }
    final theme = ThemeHelper(lastTheme);

    final Polyline polyline = Polyline(
      polylineId: PolylineId(widget.point.polyline),
      color: theme.primaryColor,
      jointType: JointType.round,
      points: polylineCoordinates,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    polylineSet.add(polyline);
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
        return GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(widget.point.enDestination.latitude, widget.point.enDestination.longitude), zoom: 16),
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
              markerId: MarkerId(widget.point.enPickup.label),
              position: LatLng(widget.point.enPickup.latitude, widget.point.enPickup.longitude),
              icon: pickupMarkerIcon ?? BitmapDescriptor.defaultMarker,
            ),
            Marker(
              markerId: MarkerId(widget.point.enDestination.label),
              position: LatLng(widget.point.enDestination.latitude, widget.point.enDestination.longitude),
              icon: destinationMarkerIcon ?? BitmapDescriptor.defaultMarker,
            ),
          ].toSet(),
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
        mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 24));
      });
    });
  }
}
