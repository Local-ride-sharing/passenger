import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/current_location.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class BasicMapWidget extends StatefulWidget {
  @override
  _BasicMapWidgetState createState() => _BasicMapWidgetState();
}

class _BasicMapWidgetState extends State<BasicMapWidget> {
  LatLng? currentLocation;

  GoogleMapController? mapController;

  String? mapStyle;

  late int lastTheme;
  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? destinationMarkerIcon;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylineSet = {};

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationCubit>(context).track();

    lastTheme = BlocProvider.of<ThemeCubit>(context).state.value;

    DefaultAssetBundle.of(context)
        .loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json')
        .then((string) {
      this.mapStyle = string;
    }).catchError((error) {});

    final CurrentLocation location = BlocProvider.of<LocationCubit>(context).state;

    currentLocation = LatLng(location.latitude, location.longitude);
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
        return BlocConsumer<LocationCubit, CurrentLocation>(
          listener: (_, state) {
            setState(() {
              currentLocation = LatLng(state.latitude, state.longitude);

              if (mapController != null) {
                mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(state.latitude, state.longitude)));
              }
            });
          },
          builder: (_, state) {
            final CurrentLocation loc = state;

            return GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 16),
              mapType: MapType.normal,
              indoorViewEnabled: false,
              onMapCreated: mapCreated,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              trafficEnabled: true,
              compassEnabled: false,
              buildingsEnabled: true,
              rotateGesturesEnabled: false,
            );
          },
        );
      },
    );
  }

  void mapCreated(GoogleMapController controller) {
    controller.getZoomLevel();
    setState(() {
      this.mapController = controller;
      if (mapStyle != null) {
        this.mapController?.setMapStyle(this.mapStyle);
      }

      final CurrentLocation loc = BlocProvider.of<LocationCubit>(context).state;
      mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(loc.latitude, loc.longitude)));
    });
  }
}
