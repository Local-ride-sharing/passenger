import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart' as permissionHandler;
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class GalleryPermissionWidget extends StatelessWidget {
  final Function onApproved;

  GalleryPermissionWidget({required this.onApproved});

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
                    "Gallery permission needed",
                    style: TextStyles.subTitle(context: context, color: theme.hintColor),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    "images/gallery-permission.png",
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
                    final Map<permissionHandler.Permission, permissionHandler.PermissionStatus> result =
                        await [permissionHandler.Permission.camera].request();

                    if (result[permissionHandler.Permission.camera] == permissionHandler.PermissionStatus.granted) {
                      onApproved();
                    }
                  },
                  child: Text("Grant permission".toUpperCase(),
                      style: TextStyles.title(context: context, color: theme.textColor)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
