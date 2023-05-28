import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/count_down_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/reservations_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/update_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/presentation/widget/profile/reservations/widget_countdown.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({Key? key}) : super(key: key);

  @override
  _ReservationHistoryScreenState createState() => _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen> {
  late Passenger passenger;

  @override
  void initState() {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;

    BlocProvider.of<ReservationsCubit>(context).monitor(passenger.reference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.profile, (route) => true);
                }),
            title: Text("Reservations",
                style: TextStyles.title(context: context, color: theme.textColor)),
          ),
          body: BlocBuilder<ReservationsCubit, ReservationsState>(
            builder: (context, state) {
              if (state is ReservationsError) {
                return Icon(Icons.error);
              } else if (state is ReservationsNetworking) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ReservationsSuccess) {
                final List<Reservation> reservation = state.data;
                return DefaultTabController(
                  length: ReservationStatus.values.length,
                  child: Scaffold(
                    backgroundColor: theme.backgroundColor,
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
                          indicatorWeight: 3,
                          indicatorColor: theme.textColor,
                          physics: ScrollPhysics(),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(text: 'Pending'),
                            Tab(text: 'Awaiting driver confirmation'),
                            Tab(text: 'Confirmed'),
                            Tab(text: 'Active'),
                            Tab(text: 'Completed'),
                            Tab(text: 'Canceled'),
                          ],
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: ReservationStatus.values.map(
                        (status) {
                          final List<Reservation> list =
                              reservation.where((element) => element.status == status).toList();

                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(color: theme.shadowColor, height: 1);
                            },
                            itemBuilder: (context, index) {
                              final Reservation reservation = list[index];
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Navigator.of(context).pushNamed(AppRouter.reservationDetails,
                                      arguments: reservation.reference);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                        leading: Icon(Icons.hail_rounded, color: theme.textColor),
                                        title: Text(reservation.pickup.label,
                                            style: TextStyles.body(
                                                context: context, color: theme.textColor)),
                                      ),
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                        leading: Icon(Icons.tour_rounded, color: theme.textColor),
                                        title: Text(reservation.destination.label,
                                            style: TextStyles.body(
                                                context: context, color: theme.textColor)),
                                      ),
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                        leading:
                                            Icon(Icons.schedule_rounded, color: theme.textColor),
                                        title: Text(
                                          DateFormat("h:mm a, dd MMM, yy").format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  reservation.departureTime)),
                                          style: TextStyles.body(
                                              context: context, color: theme.textColor),
                                        ),
                                        trailing: reservation.isRoundTrip
                                            ? Chip(
                                                backgroundColor: theme.secondaryColor,
                                                visualDensity: VisualDensity.compact,
                                                padding: EdgeInsets.only(right: 8),
                                                labelPadding: EdgeInsets.zero,
                                                avatar: Icon(Icons.repeat_rounded,
                                                    color: theme.textColor, size: 12),
                                                label: Text("round trip",
                                                    style: TextStyles.caption(
                                                        context: context, color: theme.textColor)),
                                              )
                                            : null,
                                      ),
                                      Visibility(
                                        visible: reservation.isRoundTrip,
                                        child: ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          horizontalTitleGap: 0,
                                          visualDensity:
                                              VisualDensity(horizontal: -4, vertical: -4),
                                          leading:
                                              Icon(Icons.restore_rounded, color: theme.textColor),
                                          title: Text(
                                            DateFormat("h:mm a, dd MMM, yy").format(
                                                DateTime.fromMillisecondsSinceEpoch(
                                                    reservation.returnTime ?? -1)),
                                            style: TextStyles.body(
                                                context: context, color: theme.textColor),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0,
                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                        leading: Chip(
                                          backgroundColor: theme.secondaryColor,
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.only(right: 8),
                                          labelPadding: EdgeInsets.zero,
                                          avatar: Icon(Icons.repeat_rounded,
                                              color: theme.textColor, size: 12),
                                          label: Text(
                                              "${reservation.bids.length} bid${reservation.bids.length > 1 ? "s" : ""}",
                                              style: TextStyles.caption(
                                                  context: context, color: theme.textColor)),
                                        ),
                                        trailing: reservation.status == ReservationStatus.canceled
                                            ? Chip(
                                                backgroundColor: theme.errorColor,
                                                visualDensity: VisualDensity.compact,
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                labelPadding: EdgeInsets.zero,
                                                label: Text("Canceled",
                                                    style: TextStyles.caption(
                                                        context: context,
                                                        color: theme.backgroundColor)),
                                              )
                                            : reservation.status == ReservationStatus.pending ||
                                                    reservation.status ==
                                                        ReservationStatus.awaitingDriverConfirmation
                                                ? MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                          create: (context) => CountDownCubit()),
                                                      BlocProvider(
                                                          create: (context) =>
                                                              UpdateReservationCubit()),
                                                    ],
                                                    child: ReservationBiddingDeadlineCountdown(
                                                        reservation: reservation),
                                                  )
                                                : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              } else {
                return Icon(Icons.warning);
              }
            },
          ),
        );
      },
    );
  }
}
