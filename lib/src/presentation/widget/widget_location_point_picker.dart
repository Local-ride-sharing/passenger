import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/address/saved_address_list_cubit.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/data/model/current_location.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/widget_back_button.dart';
import 'package:passenger/src/utils/constants.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class LocationPointPicker extends StatefulWidget {
  final Address? address;
  final bool? showSavedAddresses;
  final Function(Address) onFinish;

  LocationPointPicker({required this.address, required this.onFinish, this.showSavedAddresses});

  @override
  _LocationPointPickerState createState() => _LocationPointPickerState();
}

class _LocationPointPickerState extends State<LocationPointPicker> {
  Address? currentAddress;
  GoogleMapController? mapController;

  String? mapStyle;

  late int lastTheme;

  bool isDragging = false;
  bool isSearching = false;
  late Passenger passenger;

  @override
  void initState() {
    super.initState();
    currentAddress = widget.address;
    lastTheme = BlocProvider.of<ThemeCubit>(context).state.value;
    DefaultAssetBundle.of(context)
        .loadString('assets/map-${ThemeHelper(lastTheme).isDark ? "dark" : "light"}.json')
        .then((string) {
      this.mapStyle = string;
    }).catchError((error) {});
    if (currentAddress == null) {
      isSearching = true;
      final CurrentLocation location = BlocProvider.of<LocationCubit>(context).state;
      Helper.findAddress(location.latitude, location.longitude).then((value) {
        if (value != null) {
          setState(() {
            currentAddress = value;
            isSearching = false;
          });
        }
      });
    }

    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;

    if (widget.showSavedAddresses ?? false) {
      BlocProvider.of<SavedAddressCubit>(context).monitorAddress(passenger.reference);
    }
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
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(currentAddress?.latitude ?? 0, currentAddress?.longitude ?? 0), zoom: 18),
                mapType: MapType.normal,
                indoorViewEnabled: false,
                onMapCreated: mapCreated,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: false,
                trafficEnabled: false,
                compassEnabled: false,
                buildingsEnabled: true,
                rotateGesturesEnabled: false,
                gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                onCameraMoveStarted: () {
                  if (!isSearching) {
                    setState(() {
                      isDragging = true;
                    });
                  }
                },
                onCameraMove: (position) {
                  if (!isSearching) {
                    currentAddress?.latitude = position.target.latitude;
                    currentAddress?.longitude = position.target.longitude;
                  }
                },
                onCameraIdle: () async {
                  if (!isSearching && isDragging) {
                    setState(() {
                      isDragging = false;
                      isSearching = true;
                    });
                    Helper.findAddress(currentAddress?.latitude ?? 0, currentAddress?.longitude ?? 0).then((value) {
                      if (value != null) {
                        setState(() {
                          currentAddress = value;
                          isSearching = false;
                        });
                      } else {
                        setState(() {
                          isSearching = false;
                        });
                      }
                    });
                  }
                },
              ),
              Positioned(
                child: BackButtonWidget(),
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
              ),
              Center(
                child: Image.asset("images/custom-marker.png", height: isDragging ? 24 : 32),
              ),
              Positioned(
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    final theme = ThemeHelper(state.value);
                    return Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 0,
                        maxHeight: MediaQuery.of(context).size.height * .5,
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async {
                                Prediction? p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: MAP_API_WEB_KEY,
                                    mode: Mode.overlay,
                                    language: "en",
                                    radius: 10000,
                                    location: Location(lat: 22.9862194, lng: 91.3389502),
                                    components: [Component(Component.country, "bd")],
                                    logo: SizedBox(
                                      height: 54,
                                      width: MediaQuery.of(context).size.width,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "images/t-moto_text_logo.png",
                                          height: 36,
                                        ),
                                      ),
                                    ));
                                if (p != null) {
                                  try {
                                    setState(() {
                                      isSearching = true;
                                    });
                                    final places = GoogleMapsPlaces(apiKey: MAP_API_WEB_KEY);
                                    final response = await places.getDetailsByPlaceId(p.placeId ?? "");

                                    currentAddress?.label = response.result.formattedAddress ?? "";
                                    currentAddress?.latitude = response.result.geometry?.location.lat ?? 0;
                                    currentAddress?.longitude = response.result.geometry?.location.lng ?? 0;
                                    await mapController?.animateCamera(CameraUpdate.newLatLng(
                                        LatLng(currentAddress?.latitude ?? 0, currentAddress?.longitude ?? 0)));
                                    setState(() {
                                      isSearching = false;
                                    });
                                  } catch (error) {
                                    setState(() {
                                      isSearching = false;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  color: theme.errorColor.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  isSearching ? "searching" : currentAddress?.label ?? "search",
                                  style:
                                      TextStyles.body(context: context, color: isSearching ? theme.hintColor : theme.textColor),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.showSavedAddresses ?? false,
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: BlocBuilder<SavedAddressCubit, SavedAddressState>(
                                  builder: (_, state) {
                                    if (state is SavedAddressError) {
                                      return Icon(Icons.error);
                                    } else if (state is SavedAddressNetworking) {
                                      return LinearProgressIndicator();
                                    } else if (state is SavedAddressSuccess) {
                                      final List<SavedAddress> addresses = state.data;
                                      return SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          spacing: 12,
                                          children: addresses
                                              .map((e) => ActionChip(
                                                    elevation: 2,
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    labelPadding: EdgeInsets.only(right: 4),
                                                    avatar: Icon(
                                                      e.addressType == AddressType.Home
                                                          ? Icons.home
                                                          : e.addressType == AddressType.Work
                                                              ? Icons.business_center_rounded
                                                              : Icons.public,
                                                      size: 16,
                                                      color: theme.textColor,
                                                    ),
                                                    label: Text(e.label,
                                                        style: TextStyles.body(context: context, color: theme.textColor)),
                                                    backgroundColor: theme.secondaryColor,
                                                    onPressed: () {
                                                      setState(() {
                                                        isSearching = true;
                                                        currentAddress?.label = e.label;
                                                        currentAddress?.latitude = e.latitude;
                                                        currentAddress?.longitude = e.longitude;
                                                        mapController!.animateCamera(CameraUpdate.newLatLngZoom(
                                                            LatLng(
                                                                currentAddress?.latitude ?? 0, currentAddress?.longitude ?? 0),
                                                            18));
                                                      });
                                                      Future.delayed(Duration(milliseconds: 1), () {
                                                        setState(() {
                                                          isSearching = false;
                                                        });
                                                      });
                                                    },
                                                  ))
                                              .toList(),
                                        ),
                                      );
                                    } else {
                                      return Icon(Icons.help);
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 54,
                              margin: const EdgeInsets.only(top: 16),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: theme.accentColor),
                                onPressed: currentAddress == null
                                    ? null
                                    : () {
                                        widget.onFinish(currentAddress!);
                                        Navigator.of(context).pop();
                                      },
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Text("Confirm address",
                                    style: TextStyles.title(context: context, color: theme.backgroundColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                bottom: 0,
                left: 0,
                right: 0,
              )
            ],
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
      if (currentAddress == null) {
        final CurrentLocation location = BlocProvider.of<LocationCubit>(context).state;
        final LatLng currentLocation = LatLng(location.latitude, location.longitude);
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 18));
      } else {
        mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(currentAddress?.latitude ?? 0, currentAddress?.longitude ?? 0), 18));
      }
    });
  }
}
