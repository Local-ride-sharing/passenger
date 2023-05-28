import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/update_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/bid.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_label.dart';
import 'package:tmoto_passenger/src/presentation/widget/profile/reservations/widget_book_driver.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class ReservationDriverListTile extends StatefulWidget {
  final Reservation reservation;
  final Bid bid;
  final bool showHighlight;

  const ReservationDriverListTile(
      {Key? key, required this.reservation, required this.bid, required this.showHighlight})
      : super(key: key);

  @override
  _ReservationDriverListTileState createState() => _ReservationDriverListTileState();
}

class _ReservationDriverListTileState extends State<ReservationDriverListTile> {
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
        return BlocBuilder<FindSingleDriverCubit, FindSingleDriverState>(
          builder: (_, state) {
            if (state is FindSingleDriverNetworking) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 0,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                leading: Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: theme.secondaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ShimmerIcon(24, 24),
                ),
                title: Align(
                    alignment: Alignment.centerLeft, child: ShimmerLabel(size: Size(144, 12))),
              );
            } else if (state is FindSingleDriverError) {
              return Icon(Icons.error);
            } else if (state is FindSingleDriverSuccess) {
              final Driver driver = state.data;
              return Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.showHighlight &&
                            widget.reservation.isSelectedPrimarily(driver.reference)
                        ? theme.successColor
                        : theme.backgroundColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 16,
                  contentPadding: EdgeInsets.all(8),
                  visualDensity: VisualDensity.comfortable,
                  leading: Container(
                    width: 42,
                    height: 42,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        color: theme.shadowColor, borderRadius: BorderRadius.circular(42)),
                    child: driver.profilePicture.isEmpty
                        ? Icon(Icons.person_outline_rounded, color: theme.hintColor)
                        : CachedNetworkImage(
                            imageUrl: driver.profilePicture,
                            placeholder: (_, __) => ShimmerIcon(42, 42),
                            errorWidget: (_, __, ___) =>
                                Icon(Icons.person_outline_rounded, color: theme.hintColor),
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(driver.name,
                      style: TextStyles.body(context: context, color: theme.textColor)),
                  subtitle: Text(driver.vehicle.registrationNo,
                      style: TextStyles.caption(context: context, color: theme.textColor)),
                  trailing: Text("৳ ${widget.bid.amount}",
                      style: TextStyles.subHeadline(context: context, color: theme.textColor)),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider(create: (_) => FindSingleDriverCubit()),
                                BlocProvider(create: (_) => UpdateReservationCubit()),
                              ],
                              child: BookDriverBottomSheet(
                                  reservation: widget.reservation, bid: widget.bid),
                            ),
                        barrierColor: theme.shadowColor,
                        isScrollControlled: true);
                  },
                ),
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
