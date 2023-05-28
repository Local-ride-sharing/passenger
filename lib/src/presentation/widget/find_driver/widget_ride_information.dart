import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/ride/single_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class RideInformation extends StatefulWidget {
  @override
  State<RideInformation> createState() => _RideInformationState();
}

class _RideInformationState extends State<RideInformation> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<SingleRideCubit, SingleRideState>(
          builder: (_, state) {
            if (state is SingleRideError) {
              return Text(state.error);
            } else if (state is SingleRideNetworking) {
              return Text("Searching ride details",
                  style: TextStyles.caption(context: context, color: theme.textColor));
            } else if (state is SingleRideSuccess) {
              final Ride ride = state.data;
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      leading: Icon(Icons.circle_outlined, color: theme.textColor),
                      trailing: Text("${ride.distance.toString()} km",
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                      title: Text(ride.pickup.label,
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                    ),
                    ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      leading: Icon(Icons.circle, color: theme.textColor),
                      trailing: Text("${ride.duration.toString()} min",
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                      title: Text(ride.destination.label,
                          style: TextStyles.caption(context: context, color: theme.textColor)),
                    ),
                  ],
                ),
              );
            } else {
              return Text("Ride not found");
            }
          },
        );
      },
    );
  }
}
