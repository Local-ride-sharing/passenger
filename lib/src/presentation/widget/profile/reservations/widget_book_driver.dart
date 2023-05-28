import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/update_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/bid.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/presentation/widget/profile/reservations/widget_driver.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/helper.dart';
import 'package:tmoto_passenger/src/utils/networking_indicator.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class BookDriverBottomSheet extends StatefulWidget {
  final Reservation reservation;
  final Bid bid;

  const BookDriverBottomSheet({Key? key, required this.reservation, required this.bid})
      : super(key: key);

  @override
  State<BookDriverBottomSheet> createState() => _BookDriverBottomSheetState();
}

class _BookDriverBottomSheetState extends State<BookDriverBottomSheet> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () {
      BlocProvider.of<FindSingleDriverCubit>(context)
          .findDriver(context, widget.bid.driverReference);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: theme.backgroundColor,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: BlocBuilder<FindSingleDriverCubit, FindSingleDriverState>(
            builder: (context, state) {
              if (state is FindSingleDriverSuccess) {
                final Driver driver = state.data;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReservationDriverListTile(
                          bid: widget.bid, reservation: widget.reservation, showHighlight: false),
                      const SizedBox(height: 16),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              color: theme.secondaryColor, borderRadius: BorderRadius.circular(16)),
                          child: ListView.builder(
                            itemBuilder: (_, index) {
                              String url = index == 0
                                  ? driver.vehicle.frontPhoto!
                                  : driver.vehicle.interiorPhoto!;
                              String side = index == 0 ? "Front" : "Interior";
                              return Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: url,
                                    placeholder: (_, __) => Center(
                                        child: NetworkingIndicator(
                                            dimension: 54, color: theme.hintColor)),
                                    errorWidget: (_, __, ___) => Icon(
                                        Icons.photo_size_select_actual_rounded,
                                        color: theme.hintColor),
                                    width: MediaQuery.of(context).size.width - 32,
                                    height: MediaQuery.of(context).size.height,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    child: Chip(
                                      backgroundColor: theme.backgroundColor,
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.only(right: 8),
                                      labelPadding: EdgeInsets.zero,
                                      avatar: Icon(Icons.crop_free_rounded,
                                          color: theme.textColor, size: 12),
                                      label: Text(side,
                                          style: TextStyles.caption(
                                              context: context, color: theme.textColor)),
                                    ),
                                    bottom: 8,
                                    right: 8,
                                    left: 8,
                                  )
                                ],
                              );
                            },
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: !widget.reservation.isSelectedPrimarily(driver.reference),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: BlocConsumer<UpdateReservationCubit, UpdateReservationState>(
                            listener: (context, state) {
                              if (state is UpdateReservationSuccess) {
                                final String route =
                                    "'${widget.reservation.pickup.label}' to '${widget.reservation.destination.label}'";
                                Helper().publishDriverReservationConfirmationRequestNotification(
                                  widget.reservation.reference,
                                  driver.token,
                                  route,
                                );
                                Navigator.of(context).pushNamed(AppRouter.reservationHistory);
                              }
                            },
                            builder: (context, state) {
                              if (state is UpdateReservationError) {
                                return ElevatedButton(
                                  child: Text("try again".toUpperCase(),
                                      style: TextStyles.title(
                                          context: context, color: theme.textColor)),
                                  onPressed: () {
                                    final Reservation reservation = widget.reservation;
                                    reservation.primarySelection = widget.bid;
                                    reservation.status =
                                        ReservationStatus.awaitingDriverConfirmation;
                                    BlocProvider.of<UpdateReservationCubit>(context)
                                        .update(reservation);
                                  },
                                );
                              } else if (state is UpdateReservationNetworking) {
                                return ElevatedButton(
                                  child: Center(
                                      child: NetworkingIndicator(
                                          dimension: 20, color: theme.textColor)),
                                  onPressed: () {},
                                );
                              } else if (state is UpdateReservationSuccess) {
                                return ElevatedButton(
                                  child: Center(
                                      child: Icon(Icons.done_outline_rounded,
                                          color: theme.successColor)),
                                  onPressed: () {},
                                );
                              } else {
                                return ElevatedButton(
                                  child: Text("Book now".toUpperCase(),
                                      style: TextStyles.title(
                                          context: context, color: theme.textColor)),
                                  onPressed: () {
                                    final Reservation reservation = widget.reservation;
                                    reservation.primarySelection = widget.bid;
                                    reservation.status =
                                        ReservationStatus.awaitingDriverConfirmation;
                                    BlocProvider.of<UpdateReservationCubit>(context)
                                        .update(reservation);
                                    Navigator.of(context).pushNamed(AppRouter.reservationHistory);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Icon(Icons.error);
              }
            },
          ),
        );
      },
    );
  }
}
