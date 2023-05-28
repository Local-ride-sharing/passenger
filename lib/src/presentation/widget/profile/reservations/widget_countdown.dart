import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/count_down_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/update_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class ReservationBiddingDeadlineCountdown extends StatefulWidget {
  final Reservation reservation;

  const ReservationBiddingDeadlineCountdown({Key? key, required this.reservation}) : super(key: key);

  @override
  _ReservationBiddingDeadlineCountdownState createState() => _ReservationBiddingDeadlineCountdownState();
}

class _ReservationBiddingDeadlineCountdownState extends State<ReservationBiddingDeadlineCountdown> {
  @override
  void initState() {
    int timeLeft = widget.reservation.biddingDeadline - DateTime.now().millisecondsSinceEpoch;

    BlocProvider.of<CountDownCubit>(context).initiate(timeLeft ~/ 1000);
    BlocProvider.of<CountDownCubit>(context).startCountDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      final theme = ThemeHelper(state.value);
      return BlocConsumer<CountDownCubit, int>(
        listener: (_, state) {
          if (widget.reservation.status != ReservationStatus.canceled && state == 0) {
            widget.reservation.status = ReservationStatus.canceled;
            BlocProvider.of<UpdateReservationCubit>(context).update(widget.reservation);
          }
        },
        builder: (_, state) {
          final Duration duration = Duration(seconds: state);
          return Text(
            "${"${duration.inDays}d"} ${"${duration.inHours % 24}h"} ${"${duration.inMinutes % 60}m"} ${"${duration.inSeconds % 60}s"} left",
            style: TextStyles.caption(context: context, color: duration.inDays == 0 ? theme.errorColor : theme.hintColor),
          );
        },
      );
    },
    );
  }
}
