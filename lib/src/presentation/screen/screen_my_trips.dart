import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/ride_rating_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/trips/my_trips_list_cubit.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/presentation/widget/profile/my_trips/widget_my_trips_driver_information.dart';
import 'package:tmoto_passenger/src/presentation/widget/profile/my_trips/widget_my_trips_driver_profile_image.dart';
import 'package:tmoto_passenger/src/utils/alert_ratting.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class MyTripsWidget extends StatefulWidget {
  @override
  State<MyTripsWidget> createState() => _MyTripsWidgetState();
}

class _MyTripsWidgetState extends State<MyTripsWidget> with TickerProviderStateMixin {
  late TabController tabController;
  late Passenger passenger;

  int currentIndex = 0;

  final List<Tab> items = [
    Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text("Completed"),
      ),
    ),
    Tab(
        child:
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text("Canceled"))),
  ];

  List<List<Ride>> rides = [[], []];

  @override
  void initState() {
    tabController = TabController(vsync: this, length: items.length);

    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;
    BlocProvider.of<MyTripsCubit>(context).monitor(passenger.reference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.secondaryColor,
          appBar: AppBar(
            backgroundColor: theme.secondaryColor,
            automaticallyImplyLeading: true,
            title: Text(
              "My Trips",
              style: TextStyles.subTitle(context: context, color: theme.textColor),
            ),
          ),
          body: BlocConsumer<MyTripsCubit, MyTripsState>(
            listener: (context, state) {
              if (state is MyTripsSuccess) {
                setState(() {
                  rides = [
                    state.completed,
                    state.canceled,
                  ];
                });
              }
            },
            builder: (context, state) {
              if (state is MyTripsError) {
                return Icon(Icons.error);
              } else if (state is MyTripsNetworking) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MyTripsSuccess) {
                return DefaultTabController(
                  length: items.length,
                  child: Scaffold(
                    backgroundColor: theme.secondaryColor,
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(42),
                      child: Container(
                        height: 36,
                        child: TabBar(
                          unselectedLabelColor: theme.hintColor,
                          labelColor: theme.textColor,
                          labelPadding: EdgeInsets.symmetric(horizontal: 12),
                          labelStyle: TextStyles.body(context: context, color: theme.textColor)
                              .copyWith(fontWeight: FontWeight.w900),
                          unselectedLabelStyle:
                              TextStyles.body(context: context, color: theme.hintColor),
                          indicatorWeight: 2,
                          indicatorColor: theme.textColor,
                          physics: ScrollPhysics(),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: items,
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: rides.map(
                        (trips) {
                          return trips.isEmpty
                              ? Center(
                                  child: Icon(Icons.ballot_outlined,
                                      size: 144, color: theme.secondaryColor))
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 8);
                                  },
                                  itemBuilder: (context, index) {
                                    final Ride ride = trips[index];
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius: BorderRadius.circular(16)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            dense: true,
                                            visualDensity:
                                                VisualDensity(horizontal: -4, vertical: -4),
                                            horizontalTitleGap: 0,
                                            contentPadding: EdgeInsets.zero,
                                            leading: Icon(Icons.hail, color: theme.textColor),
                                            title: Text(
                                              ride.pickup.label,
                                              style: TextStyles.caption(
                                                  context: context, color: theme.textColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Text(
                                              "৳ ${ride.fare.toString()}",
                                              style: TextStyles.subTitle(
                                                  context: context, color: theme.accentColor),
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            visualDensity:
                                                VisualDensity(horizontal: -4, vertical: -4),
                                            horizontalTitleGap: 0,
                                            contentPadding: EdgeInsets.zero,
                                            leading: Icon(
                                              Icons.flag,
                                              color: theme.textColor,
                                            ),
                                            title: Text(
                                              ride.destination.label,
                                              style: TextStyles.caption(
                                                  context: context, color: theme.textColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("${ride.duration} min",
                                                    style: TextStyles.caption(
                                                            context: context,
                                                            color: theme.hintColor)
                                                        .copyWith(fontSize: 10)),
                                                SizedBox(width: 8),
                                                Icon(Icons.circle,
                                                    color: theme.secondaryColor, size: 8),
                                                SizedBox(width: 8),
                                                Text(
                                                  "${ride.distance.toStringAsFixed(1)} km",
                                                  style: TextStyles.caption(
                                                          context: context, color: theme.hintColor)
                                                      .copyWith(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: ride.startAt != null || ride.endAt != null,
                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity(horizontal: -4, vertical: -4),
                                              leading:
                                                  Icon(Icons.date_range, color: theme.textColor),
                                              horizontalTitleGap: 0,
                                              title: ride.startAt == null || ride.endAt == null
                                                  ? null
                                                  : Text(
                                                      "${DateFormat("h:mm a").format(DateTime.fromMillisecondsSinceEpoch(ride.startAt!))} - ${DateFormat("h:mm a").format(DateTime.fromMillisecondsSinceEpoch(ride.endAt!))} ${DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(ride.startAt!))}",
                                                      style: TextStyles.caption(
                                                          context: context, color: theme.textColor),
                                                    ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: ride.driverReference?.isNotEmpty ?? false,
                                            child: ListTile(
                                              dense: true,
                                              visualDensity: VisualDensity.compact,
                                              horizontalTitleGap: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: BlocProvider(
                                                create: (context) => FindSingleDriverCubit(),
                                                child: DriverProfilePic(ride),
                                              ),
                                              title: BlocProvider(
                                                create: (context) => FindSingleDriverCubit(),
                                                child: DriverInformation(ride),
                                              ),
                                              trailing: ride.rating != null
                                                  ? Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.star,
                                                            size: 18, color: theme.primaryColor),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          ride.rating!
                                                              .toStringAsFixed(2)
                                                              .toString(),
                                                          style: TextStyles.caption(
                                                              context: context,
                                                              color: theme.primaryColor),
                                                        ),
                                                      ],
                                                    )
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          theme.shadowColor.withOpacity(.07),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierColor: theme.shadowColor,
                                                            builder: (deleteContext) =>
                                                                BlocProvider(
                                                              create: (context) =>
                                                                  RideRatingCubit(),
                                                              child: RatingAlert(ride),
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(Icons.star_outline,
                                                            color: theme.primaryColor, size: 14),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(16),
                                  scrollDirection: Axis.vertical,
                                  itemCount: trips.length,
                                );
                        },
                      ).toList(),
                    ),
                  ),
                );
              } else {
                return Icon(Icons.help);
              }
            },
          ),
        );
      },
    );
  }
}
