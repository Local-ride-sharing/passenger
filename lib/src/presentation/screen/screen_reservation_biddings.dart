import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:passenger/src/business_logic/count_down_cubit.dart';
import 'package:passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:passenger/src/business_logic/reservation/bidding_cubit.dart';
import 'package:passenger/src/business_logic/reservation/update_reservation_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/bid.dart';
import 'package:passenger/src/data/model/reservation.dart';
import 'package:passenger/src/presentation/widget/profile/reservations/widget_countdown.dart';
import 'package:passenger/src/presentation/widget/profile/reservations/widget_driver.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/networking_indicator.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ReservationBiddingScreen extends StatefulWidget {
  final String reference;

  const ReservationBiddingScreen({Key? key, required this.reference}) : super(key: key);

  @override
  _ReservationBiddingScreenState createState() => _ReservationBiddingScreenState();
}

class _ReservationBiddingScreenState extends State<ReservationBiddingScreen> {
  @override
  void initState() {
    BlocProvider.of<BiddingCubit>(context).monitor(widget.reference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("Bids", style: TextStyles.title(context: context, color: theme.textColor)),
          ),
          body: BlocBuilder<BiddingCubit, BiddingState>(
            builder: (context, state) {
              if (state is BiddingError) {
                return Icon(Icons.warning);
              } else if (state is BiddingNetworking) {
                return LinearProgressIndicator();
              } else if (state is BiddingSuccess) {
                final Reservation reservation = state.data;
                final List<Bid> bids = reservation.bids;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        leading: Icon(Icons.hail_rounded, color: theme.textColor),
                        title: Text(reservation.pickup.label, style: TextStyles.body(context: context, color: theme.textColor)),
                      ),
                      ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        leading: Icon(Icons.tour_rounded, color: theme.textColor),
                        title: Text(reservation.destination.label,
                            style: TextStyles.body(context: context, color: theme.textColor)),
                      ),
                      ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        leading: Icon(Icons.schedule_rounded, color: theme.textColor),
                        title: Text(
                          DateFormat("h:mm a, dd MMM, yy")
                              .format(DateTime.fromMillisecondsSinceEpoch(reservation.departureTime)),
                          style: TextStyles.body(context: context, color: theme.textColor),
                        ),
                        trailing: reservation.isRoundTrip
                            ? Chip(
                                backgroundColor: theme.secondaryColor,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.only(right: 8),
                                labelPadding: EdgeInsets.zero,
                                avatar: Icon(Icons.repeat_rounded, color: theme.textColor, size: 12),
                                label: Text("round trip", style: TextStyles.caption(context: context, color: theme.textColor)),
                              )
                            : null,
                      ),
                      Visibility(
                        visible: reservation.isRoundTrip,
                        child: ListTile(
                          dense: true,
                          horizontalTitleGap: 0,
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          leading: Icon(Icons.restore_rounded, color: theme.textColor),
                          title: Text(
                            DateFormat("h:mm a, dd MMM, yy")
                                .format(DateTime.fromMillisecondsSinceEpoch(reservation.returnTime ?? -1)),
                            style: TextStyles.body(context: context, color: theme.textColor),
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${reservation.bids.length} bid${reservation.bids.length > 1 ? "s" : ""}",
                              style: TextStyles.subTitle(context: context, color: theme.textColor),
                            ),
                            reservation.status == ReservationStatus.canceled
                                ? Chip(
                                    backgroundColor: theme.errorColor,
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.only(right: 8),
                                    labelPadding: EdgeInsets.zero,
                                    label: Text("Canceled",
                                        style: TextStyles.caption(context: context, color: theme.backgroundColor)),
                                  )
                                : MultiBlocProvider(
                                    providers: [
                                      BlocProvider(create: (context) => CountDownCubit()),
                                      BlocProvider(create: (context) => UpdateReservationCubit()),
                                    ],
                                    child: ReservationBiddingDeadlineCountdown(reservation: reservation),
                                  )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: reservation.status == ReservationStatus.pending ||
                            reservation.status == ReservationStatus.awaitingDriverConfirmation,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          child: BlocBuilder<UpdateReservationCubit, UpdateReservationState>(
                            builder: (context, state) {
                              if (state is UpdateReservationError) {
                                return ElevatedButton(
                                  child: Text("Close bidding".toUpperCase(),
                                      style: TextStyles.title(context: context, color: theme.backgroundColor)),
                                  onPressed: () {
                                    final Reservation newReservation = reservation;
                                    newReservation.biddingDeadline = DateTime.now().millisecondsSinceEpoch;
                                    BlocProvider.of<UpdateReservationCubit>(context).update(newReservation);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.errorColor,
                                    elevation: 1,
                                    shadowColor: theme.hintColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.all(16),
                                  ),
                                );
                              } else if (state is UpdateReservationNetworking) {
                                return ElevatedButton(
                                  child: NetworkingIndicator(dimension: 20, color: theme.backgroundColor),
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.errorColor,
                                    elevation: 1,
                                    shadowColor: theme.hintColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.all(16),
                                  ),
                                );
                              } else if (state is UpdateReservationSuccess) {
                                return ElevatedButton(
                                  child: Text("Bidding closed".toUpperCase(),
                                      style: TextStyles.title(context: context, color: theme.backgroundColor)),
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.errorColor,
                                    elevation: 1,
                                    shadowColor: theme.hintColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.all(16),
                                  ),
                                );
                              } else {
                                return ElevatedButton(
                                  child: Text("Close bidding".toUpperCase(),
                                      style: TextStyles.title(context: context, color: theme.backgroundColor)),
                                  onPressed: () {
                                    final Reservation newReservation = reservation;
                                    newReservation.biddingDeadline = DateTime.now().millisecondsSinceEpoch;
                                    BlocProvider.of<UpdateReservationCubit>(context).update(newReservation);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.errorColor,
                                    elevation: 1,
                                    shadowColor: theme.hintColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.all(16),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemBuilder: (_, index) => MultiBlocProvider(
                          providers: [
                            BlocProvider(create: (_) => FindSingleDriverCubit()),
                            BlocProvider(create: (_) => UpdateReservationCubit()),
                          ],
                          child: ReservationDriverListTile(bid: bids[index], reservation: reservation, showHighlight: true),
                        ),
                        itemCount: bids.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
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
