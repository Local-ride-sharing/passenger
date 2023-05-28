import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/ride/complains_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/ride_rating_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/single_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/presentation/widget/ride_finish/widget_rating.dart';
import 'package:tmoto_passenger/src/presentation/widget/widget_price_breakdown.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class RideFinishScreen extends StatefulWidget {
  final String reference;

  RideFinishScreen(this.reference);

  @override
  _RideFinishScreenState createState() => _RideFinishScreenState();
}

class _RideFinishScreenState extends State<RideFinishScreen> {
  @override
  void initState() {
    BlocProvider.of<SingleRideCubit>(context).findRide(widget.reference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.successColor,
          body: Center(
            child: BlocBuilder<SingleRideCubit, SingleRideState>(
              builder: (_, state) {
                if (state is SingleRideError) {
                  return Icon(Icons.warning, size: 144, color: theme.errorColor);
                } else if (state is SingleRideNetworking) {
                  return CircularProgressIndicator();
                } else if (state is SingleRideSuccess) {
                  final Ride ride = state.data;
                  final DateTime start = DateTime.fromMillisecondsSinceEpoch(ride.startAt ?? 0);
                  final DateTime end = DateTime.fromMillisecondsSinceEpoch(ride.endAt ?? 0);
                  final int duration = end.difference(start).inMinutes;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.done_outline_rounded, size: 144, color: theme.backgroundColor),
                      SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "৳ ${ride.fare}",
                            style:
                                TextStyles.headline(context: context, color: theme.backgroundColor),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context, builder: (_) => PriceBreakdownWidget(ride));
                            },
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            icon: Icon(Icons.info_outline_rounded, color: theme.backgroundColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$duration min",
                            style: TextStyles.body(context: context, color: theme.backgroundColor),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.circle, color: theme.shadowColor, size: 8),
                          SizedBox(width: 8),
                          Text(
                            "${ride.distance.toStringAsFixed(1)} km",
                            style: TextStyles.body(context: context, color: theme.backgroundColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          ///TODO: change single ride cubit to ride rating cubit
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(create: (_) => ComplainsCubit()),
                                  BlocProvider(create: (_) => RideRatingCubit()),
                                ],
                                child: RideFinishRatingWidget(ride),
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [1, 2, 3, 4, 5]
                              .map((e) => Icon(Icons.star_border_rounded,
                                  color: theme.backgroundColor, size: 42))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 54),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(AppRouter.dashboard, (route) => false);
                        },
                        child: Text("Back to dashboard",
                            style:
                                TextStyles.subTitle(context: context, color: theme.successColor)),
                      ),
                    ],
                  );
                } else {
                  return Icon(Icons.done_outline_rounded, size: 144, color: theme.backgroundColor);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
