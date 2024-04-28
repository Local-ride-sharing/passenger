import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/ride/cancel_ride_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/presentation/inherited/inherited_ride.dart';
import 'package:passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:passenger/src/presentation/widget/find_driver/widget_rating.dart';
import 'package:passenger/src/presentation/widget/find_driver/widget_total_ride.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FindDriverCurrentAssignedDriver extends StatelessWidget {
  final Driver driver;

  FindDriverCurrentAssignedDriver({required this.driver});

  @override
  Widget build(BuildContext context) {
    final Ride ride = InheritedRide.of(context).ride;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return PhysicalModel(
          color: theme.backgroundColor,
          shadowColor: theme.secondaryColor,
          elevation: 8,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: driver.profilePicture.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: driver.profilePicture,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => ShimmerIcon(36, 36),
                            errorWidget: (_, __, ___) => Center(child: Icon(Icons.person_outline_rounded)),
                          )
                        : Center(child: Icon(Icons.person_outline_rounded)),
                  ),
                  title: Text(driver.name, style: TextStyles.body(context: context, color: theme.textColor)),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DriverRating(),
                      SizedBox(width: 8),
                      Icon(Icons.circle, color: theme.shadowColor, size: 8),
                      SizedBox(width: 8),
                      DriverTotalRides(),
                    ],
                  ),
                  trailing: IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.call, color: theme.iconColor),
                    onPressed: () {
                      launchUrlString("tel:${driver.phone}");
                    },
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                Text(
                  "${driver.vehicle.chassis} (${driver.vehicle.color})",
                  style: TextStyles.caption(context: context, color: theme.hintColor),
                ),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: BlocConsumer<CancelRideCubit, CancelRideState>(
                    listener: (_, state) {
                      if (state is CancelRideSuccess) {
                        Helper().publishRideCancellationNotification(ride, driver);
                        Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.dashboard, (route) => false);
                      }
                    },
                    builder: (_, state) {
                      if (state is CancelRideError) {
                        return ElevatedButton(
                          onPressed: () {
                            ride.isCanceled = true;
                            BlocProvider.of<CancelRideCubit>(context).cancelRide(ride);
                          },
                          child: Text("Try again", style: TextStyles.title(context: context, color: theme.errorColor)),
                        );
                      } else if (state is CancelRideNetworking) {
                        return ElevatedButton(
                          onPressed: () {},
                          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(theme.errorColor))),
                        );
                      } else if (state is CancelRideSuccess) {
                        return ElevatedButton(
                          onPressed: () {},
                          child: Text("Canceled", style: TextStyles.title(context: context, color: theme.errorColor)),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            ride.isCanceled = true;
                            BlocProvider.of<CancelRideCubit>(context).cancelRide(ride);
                          },
                          child: Text("Cancel ride", style: TextStyles.title(context: context, color: theme.errorColor)),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
