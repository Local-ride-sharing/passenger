import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/ride/cancel_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class RideAlert extends StatefulWidget {
  final Ride ride;

  RideAlert(this.ride);

  @override
  State<RideAlert> createState() => _RideAlertState();
}

class _RideAlertState extends State<RideAlert> {
  double rating = 0;
  TextEditingController commentsController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Text("Do you want to cancel the ride?",
                  style: TextStyles.body(context: context, color: theme.textColor)),
              SizedBox(
                height: 24,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            primary: theme.errorColor,
                            side: BorderSide(color: theme.errorColor, width: 1)),
                        child: Text("cancel".toUpperCase(),
                            style: TextStyles.body(context: context, color: theme.errorColor)),
                        onPressed: () async {
                          widget.ride.isCanceled = true;
                          BlocProvider.of<CancelRideCubit>(context).cancelRide(widget.ride);
                          await Navigator.of(context)
                              .pushNamedAndRemoveUntil(AppRouter.dashboard, (route) => false);
                        },
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: theme.errorColor,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                        child: Text("continue".toUpperCase(),
                            style: TextStyles.body(context: context, color: theme.backgroundColor)),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}
