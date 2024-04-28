import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/passenger/update_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class SaveStatesForEditProfile extends StatelessWidget {
  final String reference;
  final String name;
  final Gender gender;
  final int dob;
  final String phone;
  final String imageUrl;

  SaveStatesForEditProfile(
      {required this.reference,
      required this.name,
      required this.gender,
      required this.dob,
      required this.phone,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<UpdateCubit, UpdateState>(
          builder: (builderContext, state) {
            if (state is UpdateError) {
              return ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final String token = await FirebaseMessaging.instance.getToken() ?? "";
                  final Passenger passenger = Passenger(reference, name, gender, dob, phone, imageUrl, token, true);
                  BlocProvider.of<UpdateCubit>(context).update(passenger);
                },
                child:
                    Text("Try again".toUpperCase(), style: TextStyles.title(context: builderContext, color: theme.errorColor)),
              );
            } else if (state is UpdateNetworking) {
              return ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                },
                child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
              );
            } else if (state is UpdateSuccess) {
              return ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                },
                child:
                    Text("Updated".toUpperCase(), style: TextStyles.title(context: builderContext, color: theme.successColor)),
              );
            } else {
              return ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final String token = await FirebaseMessaging.instance.getToken() ?? "";
                  final Passenger passenger = Passenger(reference, name, gender, dob, phone, imageUrl, token, true);
                  BlocProvider.of<UpdateCubit>(context).update(passenger);
                },
                child: Text("Update profile".toUpperCase(),
                    style: TextStyles.title(context: builderContext, color: theme.textColor)),
              );
            }
          },
        );
      },
    );
  }
}
