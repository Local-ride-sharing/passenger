import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class MyTripsDateTimeWidget extends StatelessWidget {
  final Ride ride;

  MyTripsDateTimeWidget(this.ride);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          leading: Icon(Icons.date_range, color: theme.textColor),
          horizontalTitleGap: 0,
          title: ride.startAt == null || ride.endAt == null
              ? null
              : Text(
                  "${DateFormat("h:mm a").format(DateTime.fromMillisecondsSinceEpoch(ride.startAt!))} - ${DateFormat("h:mm a").format(DateTime.fromMillisecondsSinceEpoch(ride.endAt!))} ${DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(ride.startAt!))}",
                  style: TextStyles.caption(context: context, color: theme.textColor),
                ),
        );
      },
    );
  }
}
