import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/driver/driver_rides_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/presentation/shimmer/shimmer_label.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class DriverTotalRides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<DriverRidesCubit, DriverRidesState>(builder: (_, state) {
          if (state is DriverRidesError) {
            return Text("no rides", style: TextStyles.caption(context: context, color: theme.hintColor));
          } else if (state is DriverRidesNetworking) {
            return ShimmerLabel(size: Size(72, 12));
          } else if (state is DriverRidesSuccess) {
            return Text(
              "${Helper.totalRides(state.data)} ride${Helper.totalRides(state.data) > 1 ? "s" : ""}",
              style: TextStyles.caption(context: context, color: theme.hintColor),
            );
          } else {
            return Text("No total amount", style: TextStyles.caption(context: context, color: theme.hintColor));
          }
        });
      },
    );
  }
}
