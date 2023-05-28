import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/driver_rides_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_label.dart';
import 'package:tmoto_passenger/src/utils/helper.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class DriverRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<DriverRidesCubit, DriverRidesState>(builder: (_, state) {
          if (state is DriverRidesError) {
            return Text("no rating", style: TextStyles.caption(context: context, color: theme.hintColor));
          } else if (state is DriverRidesNetworking) {
            return ShimmerLabel(size: Size(54, 12));
          } else if (state is DriverRidesSuccess) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: theme.hintColor, size: 16),
                SizedBox(width: 4),
                Text(Helper.totalRatings(state.data).toStringAsFixed(2), style: TextStyles.caption(context: context, color: theme.hintColor))
              ],
            );
          } else {
            return Text("no rating", style: TextStyles.caption(context: context, color: theme.hintColor));
          }
        });
      },
    );
  }
}
