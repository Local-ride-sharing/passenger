import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissionHandler;
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class LocationPermissionWidget extends StatelessWidget {
  final Function onApproved;

  LocationPermissionWidget({required this.onApproved});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Location permission needed",
                    style: TextStyles.subTitle(context: context, color: theme.hintColor),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    "images/location-permission.png",
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .5,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    final Map<permissionHandler.Permission, permissionHandler.PermissionStatus> result = await [
                      permissionHandler.Permission.locationAlways,
                      permissionHandler.Permission.locationWhenInUse,
                      permissionHandler.Permission.location,
                    ].request();

                    if (result[permissionHandler.Permission.location] == permissionHandler.PermissionStatus.granted ||
                        result[permissionHandler.Permission.locationAlways] == permissionHandler.PermissionStatus.granted ||
                        result[permissionHandler.Permission.locationWhenInUse] == permissionHandler.PermissionStatus.granted) {
                      await Location.instance.requestService();
                      await Location.instance.requestPermission();
                      await Location.instance.changeSettings(accuracy: LocationAccuracy.high, interval: 0, distanceFilter: 0);
                      onApproved();
                    }
                  },
                  child:
                      Text("Grant permission".toUpperCase(), style: TextStyles.title(context: context, color: theme.textColor)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
