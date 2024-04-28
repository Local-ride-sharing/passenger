import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/ride/cancel_ride_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/utils/alert_cancel_ride.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class BackButtonFindDriverWidget extends StatelessWidget {
  final Ride ride;

  BackButtonFindDriverWidget(this.ride);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return IconButton(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => BlocProvider(
                      create: (context) => CancelRideCubit(),
                      child: RideAlert(ride),
                    ));
          },
          icon: CircleAvatar(
            backgroundColor: theme.backgroundColor,
            child: Icon(Icons.arrow_back, color: theme.iconColor),
          ),
        );
      },
    );
  }
}
