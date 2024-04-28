import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/profile/whidget_profile_picture.dart';
import 'package:passenger/src/presentation/widget/profile/widget_menu.dart';
import 'package:passenger/src/presentation/widget/profile/widget_theme.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/constants.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int themeValue = -1;
  String phone = "+8809613820001";
  String phone999 = "999";

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final Passenger passenger = profileProvider.profile!;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.dashboard, (route) => false);
                }),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.editProfile);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondaryColor, padding: EdgeInsets.symmetric(horizontal: 16)),
                  icon: Icon(Icons.edit_outlined, color: theme.primaryColor, size: 24),
                  label: Text("Edit", style: TextStyles.subTitle(context: context, color: theme.primaryColor)),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 88,
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(child: ProfilePictureWidget(passenger), width: 128, height: 128),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                          passenger.name.contains(" ")
                              ? passenger.name.split(" ").first.toUpperCase()
                              : passenger.name.toUpperCase(),
                          style: TextStyles.title(context: context, color: theme.textColor)),
                    ),
                    Visibility(visible: passenger.name.contains(" "), child: SizedBox(height: 4)),
                    Visibility(
                      visible: passenger.name.contains(" "),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(passenger.name.replaceAll(passenger.name.split(" ").first, "").trim().toUpperCase(),
                            style: TextStyles.subTitle(context: context, color: theme.textColor)),
                      ),
                    ),
                    SizedBox(height: 12),
                    ProfileMenu(
                        icon: MdiIcons.listStatus,
                        label: "My trips",
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRouter.myTrips);
                        }),
                    ProfileMenu(
                      icon: MdiIcons.calendarOutline,
                      label: "Reservations",
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRouter.reservationHistory);
                      },
                    ),
                    ProfileMenu(
                      icon: Icons.business,
                      label: "Saved address",
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRouter.savedAddresses);
                      },
                    ),
                    ProfileMenu(
                      icon: Icons.color_lens_outlined,
                      label: "Change theme",
                      onTap: () {
                        showModalBottomSheet(context: context, builder: (context) => ThemeWidget());
                      },
                    ),
                    ProfileMenu(
                      icon: Icons.phone,
                      label: "Call center support",
                      onTap: () {
                        launch("tel:$phone");
                      },
                    ),
                    ProfileMenu(
                      icon: Icons.help,
                      label: "Call 999",
                      onTap: () {
                        launch("tel:$phone999");
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
                      },
                      icon: Icon(Icons.logout, color: theme.errorColor, size: 24),
                      label: Text("Sign Out", style: TextStyles.title(context: context, color: theme.errorColor)),
                    ),
                    Text(appVersion, style: TextStyles.caption(context: context, color: theme.hintColor)),
                  ],
                ),
                right: 16,
                left: 16,
                bottom: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
