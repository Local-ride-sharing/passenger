import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/login/existence_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/passenger/profile_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/presentation/widget/initialize_states/widget_initialise_existence.dart';
import 'package:tmoto_passenger/src/presentation/widget/initialize_states/widget_initialise_profile.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/helper.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class InitialiseInformationScreen extends StatefulWidget {
  @override
  _InitialiseInformationScreenState createState() => _InitialiseInformationScreenState();
}

class _InitialiseInformationScreenState extends State<InitialiseInformationScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExistenceCubit>(context).check();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShakeAnimatedWidget(
                      enabled: true,
                      duration: Duration(milliseconds: 1500),
                      shakeAngle: Rotation.deg(z: 25),
                      curve: Curves.fastOutSlowIn,
                      child: Image.asset("images/logo.png", width: 144, height: 144),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<ExistenceCubit, ExistenceState>(
                      listener: (_, state) {
                        if (state is ExistenceSuccess) {
                          if (state.exists) {
                            BlocProvider.of<ProfileCubit>(context).monitor(state.passenger?.reference ?? "");
                            final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                            profileProvider.saveProfile(state.passenger!);
                          } else {
                            Navigator.of(context).pushReplacementNamed(AppRouter.registration);
                          }
                        } else {

                        }
                      },
                    ),
                    BlocListener<ProfileCubit, ProfileState>(
                      listener: (_, state) {
                        if (state is ProfileSuccess) {
                          final Passenger passenger = state.data;
                          if (passenger.isActive) {
                            profileProvider.saveProfile(passenger);
                            Future.delayed(Duration(milliseconds: 1), () {
                              Navigator.of(context).pushReplacementNamed(AppRouter.dashboard);
                            });
                          } else {
                            ///Todo: show alert dialog for in-active user
                          }
                        } else if (state is ProfileError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(getErrorSnackBar(context, state.error));
                        }
                      },
                    ),
                  ],
                  child: InitialiseExistenceWidget(
                    child: InitialiseProfileWidget(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
