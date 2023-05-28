import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_label.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class DriverInformation extends StatefulWidget {
  final Ride ride;

  DriverInformation(this.ride);

  @override
  _DriverInformationState createState() => _DriverInformationState();
}

class _DriverInformationState extends State<DriverInformation> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1),(){
      BlocProvider.of<FindSingleDriverCubit>(context).findDriver(context, widget.ride.driverReference ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<FindSingleDriverCubit, FindSingleDriverState>(
          builder: (_, state) {
            if (state is FindSingleDriverNetworking) {
              return ShimmerLabel(size: Size(MediaQuery.of(context).size.width, 48));
            } else if (state is FindSingleDriverSuccess) {
              final Driver driver = state.data;
              return Text(
                driver.name,
                style: TextStyles.body(context: context, color: theme.textColor),
              );
            } else {
              return Text("Not found");
            }
          },
        );
      },
    );
  }
}
