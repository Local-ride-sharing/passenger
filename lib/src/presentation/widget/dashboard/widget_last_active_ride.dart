import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/cancel_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/helper.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class LastActiveRide extends StatelessWidget {
  final Ride ride;
  final Function() onCancel;

  LastActiveRide(this.ride, this.onCancel);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocListener<CancelRideCubit, CancelRideState>(
          listener: (context, state) {
            if (state is CancelRideSuccess) {
              onCancel();
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (ride.driverReference == null) {
                        Navigator.of(context).pushNamed(AppRouter.findDriver, arguments: ride);
                      } else {
                        if (ride.startAt == null) {
                          Navigator.of(context).pushNamed(AppRouter.driverArrivalTracking,
                              arguments: ride.reference);
                        } else {
                          Navigator.of(context)
                              .pushNamed(AppRouter.rideNavigation, arguments: ride.reference);
                        }
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.hail, color: theme.textColor),
                          title: Text(
                            ride.pickup.label,
                            style: TextStyles.caption(context: context, color: theme.textColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "৳ ${ride.fare}",
                              style:
                                  TextStyles.subTitle(context: context, color: theme.accentColor),
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          horizontalTitleGap: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.flag,
                            color: theme.textColor,
                          ),
                          title: Text(
                            ride.destination.label,
                            style: TextStyles.caption(context: context, color: theme.textColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${ride.duration} min",
                                  style:
                                      TextStyles.caption(context: context, color: theme.hintColor)
                                          .copyWith(fontSize: 10)),
                              SizedBox(width: 8),
                              Icon(Icons.circle, color: theme.hintColor, size: 8),
                              SizedBox(width: 8),
                              Text(
                                "${ride.distance.toStringAsFixed(1)} km",
                                style: TextStyles.caption(context: context, color: theme.hintColor)
                                    .copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<SingleDriverCubit, SingleDriverState>(
                          builder: (_, state) {
                            if (state is SingleDriverError) {
                              return Icon(Icons.error);
                            } else if (state is SingleDriverNetworking) {
                              return CircularProgressIndicator();
                            } else if (state is SingleDriverSuccess) {
                              final Driver driver = state.data;
                              return BlocConsumer<CancelRideCubit, CancelRideState>(
                                listener: (_, state) {
                                  if (state is CancelRideSuccess) {
                                    Helper().publishRideCancellationNotification(ride, driver);
                                  }
                                },
                                builder: (_, state) {
                                  if (state is CancelRideError) {
                                    return Icon(Icons.error);
                                  } else if (state is CancelRideNetworking) {
                                    return Center(
                                        child: CircularProgressIndicator(color: theme.errorColor));
                                  } else if (state is CancelRideSuccess) {
                                    return Icon(Icons.done);
                                  } else {
                                    return ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                      horizontalTitleGap: 0,
                                      contentPadding: EdgeInsets.zero,
                                      trailing: TextButton(
                                        style: TextButton.styleFrom(
                                            primary: theme.errorColor,
                                            backgroundColor: theme.errorColor.withOpacity(.07),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16))),
                                        onPressed: () {
                                          BlocProvider.of<CancelRideCubit>(context)
                                              .cancelRide(ride);
                                        },
                                        child: Text(
                                          "Cancel ride",
                                          style: TextStyles.caption(
                                              context: context, color: theme.errorColor),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return Icon(Icons.help);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                LinearProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
