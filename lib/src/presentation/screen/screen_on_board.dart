import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/presentation/widget/onboard/widget_gallery_permission.dart';
import 'package:tmoto_passenger/src/presentation/widget/onboard/widget_location_permission.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: [
            LocationPermissionWidget(
              onApproved: () {
                setState(() {
                  ++currentIndex;
                });
              },
            ),
            GalleryPermissionWidget(
              onApproved: () async {
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setBool("onboard", false);
                Navigator.of(context).pushReplacementNamed(AppRouter.launcher);
              },
            ),
          ][currentIndex],
        );
      },
    );
  }
}
