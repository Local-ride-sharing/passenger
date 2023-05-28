import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tmoto_passenger/src/business_logic/ride/complains_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/ride_rating_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/complains.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class RideFinishRatingWidget extends StatefulWidget {
  final Ride ride;

  RideFinishRatingWidget(this.ride);

  @override
  _RideFinishRatingWidgetState createState() => _RideFinishRatingWidgetState();
}

class _RideFinishRatingWidgetState extends State<RideFinishRatingWidget> {
  double rating = 0;

  final List<String> complainSelections = [];

  @override
  void initState() {
    BlocProvider.of<ComplainsCubit>(context).monitorComplains();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("Rate your experience", style: TextStyles.title(context: context, color: theme.primaryColor)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 54),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text("rate your experience",
                      style: TextStyles.caption(context: context, color: theme.hintColor), textAlign: TextAlign.center),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.topCenter,
                  child: RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    glow: false,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    maxRating: 5,
                    itemCount: 5,
                    wrapAlignment: WrapAlignment.center,
                    unratedColor: theme.shadowColor,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(Icons.star, color: theme.primaryColor),
                    onRatingUpdate: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Divider(color: theme.hintColor),
                SizedBox(height: 16),
                Text("Share your complains, if you have any", style: TextStyles.caption(context: context, color: theme.hintColor)),
                SizedBox(height: 8),
                BlocBuilder<ComplainsCubit, ComplainsState>(
                  builder: (context, state) {
                    if (state is ComplainsError) {
                      return Icon(Icons.warning_rounded, color: theme.errorColor);
                    } else if (state is ComplainsNetworking) {
                      return CircularProgressIndicator();
                    } else if (state is ComplainsSuccess) {
                      List<Complains> complains = state.data;
                      return Wrap(
                        direction: Axis.horizontal,
                        children: complains
                            .map(
                              (e) => ActionChip(
                                backgroundColor:
                                    complainSelections.contains(e.reference) ? theme.primaryColor : theme.secondaryColor,
                                label: Text(
                                  e.enComplain,
                                  style: TextStyles.body(
                                      context: context,
                                      color: complainSelections.contains(e.reference) ? theme.backgroundColor : theme.textColor),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (complainSelections.contains(e.reference)) {
                                      complainSelections.remove(e.reference);
                                    } else {
                                      complainSelections.add(e.reference);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(height: 24),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: BlocConsumer<RideRatingCubit, RideRatingState>(
                    listener: (context, state) {
                      if(state is RideRatingSuccess) {
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is RideRatingError) {
                        return ElevatedButton(
                          onPressed: () {
                            widget.ride.rating = rating.toInt();
                            widget.ride.complains = complainSelections;
                            BlocProvider.of<RideRatingCubit>(context).submit(widget.ride);
                          },
                          child:
                              Text("Try again".toUpperCase(), style: TextStyles.title(context: context, color: theme.errorColor)),
                        );
                      } else if (state is RideRatingNetworking) {
                        return ElevatedButton(
                          onPressed: () {},
                          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
                        );
                      } else if (state is RideRatingSuccess) {
                        return ElevatedButton(
                          onPressed: () {},
                          child: Icon(Icons.done_outline_rounded, color: theme.successColor),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            widget.ride.rating = rating.toInt();
                            widget.ride.complains = complainSelections;
                            BlocProvider.of<RideRatingCubit>(context).submit(widget.ride);
                          },
                          child: Text(
                            "Finish".toUpperCase(),
                            style: TextStyles.title(context: context, color: theme.primaryColor),
                          ),
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
