import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/registration/registration_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class SignUpStatesForRegistration extends StatelessWidget {
  final String reference;
  final String name;
  final Gender gender;
  final int dob;
  final String phone;
  final String? imageUrl;

  SignUpStatesForRegistration(
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
        return BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (builderContext, state) {
            if (state is RegistrationError) {
              return ElevatedButton(
                onPressed: () async {
                  final String token = await FirebaseMessaging.instance.getToken() ?? "";
                  final Passenger passenger = Passenger(reference, name, gender, dob, phone, imageUrl, token, true);
                  BlocProvider.of<RegistrationCubit>(context).save(passenger);
                },
                child: Text("Signup failed".toUpperCase(),
                    style: TextStyles.title(context: builderContext, color: theme.errorColor)),
              );
            } else if (state is RegistrationNetworking) {
              return ElevatedButton(
                onPressed: () async {},
                child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
              );
            } else if (state is RegistrationSuccess) {
              return ElevatedButton(
                onPressed: () async {},
                child: Text("Account created".toUpperCase(),
                    style: TextStyles.title(context: builderContext, color: theme.successColor)),
              );
            } else {
              return ElevatedButton(
                onPressed: () async {
                  final String token = await FirebaseMessaging.instance.getToken() ?? "";
                  final Passenger passenger = Passenger(reference, name, gender, dob, phone, imageUrl, token, true);
                  BlocProvider.of<RegistrationCubit>(context).save(passenger);
                },
                child: Text("Create account".toUpperCase(),
                    style: TextStyles.title(context: builderContext, color: theme.textColor)),
              );
            }
          },
        );
      },
    );
  }
}
