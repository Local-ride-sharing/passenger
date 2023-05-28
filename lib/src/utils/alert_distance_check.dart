import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class DirectionDistanceCheckAlert extends StatelessWidget {
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
              Text("Your distance is less then 1 km!",
                  style: TextStyles.body(context: context, color: theme.errorColor)),
              SizedBox(
                height: 24,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: theme.errorColor, side: BorderSide(color: theme.errorColor, width: 1)),
                child: Text("Ok".toUpperCase(),
                    style: TextStyles.body(context: context, color: theme.errorColor)),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
