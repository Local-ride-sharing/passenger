import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:passenger/src/business_logic/ride/ride_rating_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class RatingAlert extends StatefulWidget {
  final Ride ride;

  RatingAlert(this.ride);

  @override
  State<RatingAlert> createState() => _RatingAlertState();
}

class _RatingAlertState extends State<RatingAlert> {
  double rating = 0;
  TextEditingController commentsController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              RatingBar.builder(
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
              Container(
                height: 54,
                child: TextField(
                  controller: commentsController,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  style: TextStyles.body(context: context, color: theme.textColor),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    fillColor: theme.shadowColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: BlocConsumer<RideRatingCubit, RideRatingState>(
                  listener: (context, state) {
                    if (state is RideRatingSuccess) {
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    if (state is RideRatingError) {
                      return ElevatedButton(
                        onPressed: () {
                          widget.ride.rating = rating.toInt();
                          widget.ride.comments = commentsController.text.toString();
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
                          if (rating != 0) {
                            widget.ride.rating = rating.toInt();
                            widget.ride.comments = commentsController.text.toString();
                            BlocProvider.of<RideRatingCubit>(context).submit(widget.ride);
                          }
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
        );
      },
    );
  }
}
