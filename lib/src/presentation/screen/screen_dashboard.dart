import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/address/saved_address_list_cubit.dart';
import 'package:passenger/src/business_logic/dashboard/instant_ride_cubit.dart';
import 'package:passenger/src/business_logic/dashboard/point_vehicle_cubit.dart';
import 'package:passenger/src/business_logic/dashboard/reservation_vehicle_cubit.dart';
import 'package:passenger/src/business_logic/passenger/profile_cubit.dart';
import 'package:passenger/src/business_logic/passenger/update_cubit.dart';
import 'package:passenger/src/business_logic/ride/cancel_ride_cubit.dart';
import 'package:passenger/src/business_logic/ride/rides_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/data/provider/provider_vehicle.dart';
import 'package:passenger/src/presentation/widget/dashboard/widget__initial_menu.dart';
import 'package:passenger/src/presentation/widget/dashboard/widget_dashboard_curve.dart';
import 'package:passenger/src/presentation/widget/dashboard/widget_last_active_ride.dart';
import 'package:passenger/src/presentation/widget/dashboard/widget_profile_picture.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<SavedAddress> savedAddresses = [];
  late Passenger passenger;

  final List<DashboardMenu> menus = [
    DashboardMenu(image: "images/ride.png", name: "Instant Ride", route: AppRouter.instantRide),
    DashboardMenu(image: "images/point.png", name: "Point-to-point", route: AppRouter.pointRide),
    DashboardMenu(
      image: "images/ambulance.png",
      name: "Ambulance",
      route: AppRouter.bookReservation,
      isAmbulance: true,
    ),
    DashboardMenu(image: "images/reservations.png", name: "Reservations", route: AppRouter.bookReservation),
  ];

  @override
  void initState() {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;
    BlocProvider.of<InstantRideVehicleCubit>(context).monitorVehicles();
    BlocProvider.of<PointVehicleCubit>(context).monitorVehicles();
    BlocProvider.of<ReservationVehicleCubit>(context).monitorVehicles();
    BlocProvider.of<SavedAddressCubit>(context).monitorAddress(passenger.reference);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      if (data["category"] == "ride-accepted") {
        final String reference = data["reference"];
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRouter.driverArrivalTracking, arguments: reference);
        }
      }
    });

    FirebaseMessaging.instance.getToken().then((token) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final Passenger profile = profileProvider.profile!;
      profile.token = token ?? "";

      BlocProvider.of<UpdateCubit>(context).update(profile);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;
      if (data["category"] == "ride-accepted") {
        final String reference = data["reference"];
        Navigator.of(context).pushReplacementNamed(AppRouter.driverArrivalTracking, arguments: reference);
      }
    });

    BlocProvider.of<RidesCubit>(context).monitor(passenger.reference);

    super.initState();
  }

  bool showCurrentRide = false;
  Ride? lastRide;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final Passenger? profile = profileProvider.profile;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return MultiBlocListener(
          listeners: [
            BlocListener<ProfileCubit, ProfileState>(
              listener: (_, state) {
                if (state is ProfileSuccess) {
                  profileProvider.saveProfile(state.data);
                }
              },
            ),
            BlocListener<InstantRideVehicleCubit, InstantRideVehicleState>(
              listener: (_, state) {
                if (state is InstantRideVehicleSuccess) {
                  final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
                  vehicleProvider.addAll(state.data);
                }
              },
            ),
            BlocListener<RidesCubit, RidesState>(
              listener: (_, state) {
                if (state is RidesSuccess) {
                  final List<Ride> rides = state.data;
                  rides.sort((b, a) => a.createdAt.compareTo(b.createdAt));
                  final DateTime now = DateTime.now();
                  if (rides.isNotEmpty &&
                      rides.first.createdAt > DateTime(now.year, now.month, now.day, 0, 0, 0).millisecondsSinceEpoch &&
                      rides.first.rideCurrentStatus != RideCurrentStatus.finished &&
                      !(rides.first.isCanceled ?? true)) {
                    setState(() {
                      showCurrentRide = true;
                      lastRide = rides.first;
                    });
                  }
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: theme.secondaryColor,
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.profile);
                },
                leading: DashboardProfilePicture(),
                horizontalTitleGap: 8,
                title: Text(Helper.greetings, style: TextStyles.caption(context: context, color: theme.backgroundColor)),
                subtitle: Text(
                  profile?.name ?? "-",
                  style: TextStyles.subTitle(context: context, color: theme.backgroundColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    child: Container(
                      color: Colors.red,
                      height: 150.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            "All in #1 ride sharing platform!",
                            textAlign: TextAlign.justify,
                            style:
                                TextStyles.body(context: context, color: Colors.white60).copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            """We want to make that dream happen.\nValue your time,time will value you.\nRide Local ride,Save time.""",
                            textAlign: TextAlign.left,
                            maxLines: 4,
                            style: TextStyles.caption(context: context, color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                    clipper: HeaderCurvedContainer(),
                  ),
                  Positioned(
                    top: 64,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemBuilder: (_, index) {
                              return menus.elementAt(index);
                            },
                            itemCount: menus.length,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                            ),
                          ),
                          SizedBox(height: 24),
                          Visibility(
                            child: lastRide != null
                                ? BlocProvider(
                                    create: (context) => CancelRideCubit(),
                                    child: LastActiveRide(lastRide!, () {
                                      setState(() {
                                        lastRide = null;
                                        showCurrentRide = false;
                                      });
                                    }),
                                  )
                                : Container(),
                            visible: showCurrentRide,
                          ),
                          BlocBuilder<SavedAddressCubit, SavedAddressState>(
                            builder: (context, state) {
                              if (state is SavedAddressError) {
                                return Center(child: Icon(Icons.error_outline));
                              } else if (state is SavedAddressNetworking) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is SavedAddressSuccess) {
                                savedAddresses = state.data;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 48,
                                      decoration:
                                          BoxDecoration(color: theme.backgroundColor, borderRadius: BorderRadius.circular(16)),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Text("Where to?",
                                          style: TextStyles.body(context: context, color: theme.textColor)
                                              .copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 8),
                                    ListView.separated(
                                      padding: EdgeInsets.all(0),
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (listContext, index) {
                                        final SavedAddress address = savedAddresses[index];
                                        return ListTile(
                                          dense: true,
                                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                          contentPadding: EdgeInsets.all(0),
                                          leading: CircleAvatar(
                                            child: Icon(
                                              address.addressType == AddressType.Home
                                                  ? Icons.home
                                                  : address.addressType == AddressType.Work
                                                      ? Icons.work_outlined
                                                      : Icons.public,
                                              color: theme.hintColor,
                                            ),
                                            backgroundColor: theme.secondaryColor,
                                          ),
                                          title: Text(address.label,
                                              style: TextStyles.body(context: context, color: theme.primaryColor)),
                                          subtitle: Text(
                                              address.addressType == AddressType.Home
                                                  ? "Home"
                                                  : address.addressType == AddressType.Work
                                                      ? "Work"
                                                      : "Other",
                                              style: TextStyles.caption(context: context, color: theme.hintColor)),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(AppRouter.instantRide, arguments: address.address);
                                          },
                                        );
                                      },
                                      itemCount: savedAddresses.length,
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Divider(thickness: .4, height: 1);
                                      },
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(context, AppRouter.newSavedAddress);
                                      },
                                      dense: true,
                                      contentPadding: EdgeInsets.all(0),
                                      visualDensity: VisualDensity.compact,
                                      leading: CircleAvatar(child: Icon(Icons.add), backgroundColor: theme.secondaryColor),
                                      title: Text("Choose a new address",
                                          style: TextStyles.body(context: context, color: theme.textColor)),
                                    )
                                  ],
                                );
                              } else {
                                return Center(child: Icon(Icons.error_rounded));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
