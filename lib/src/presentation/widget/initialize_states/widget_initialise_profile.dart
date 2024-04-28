import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/passenger/profile_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class InitialiseProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (builderContext, state) {
            if (state is ProfileError) {
              return Text(state.error,
                  textAlign: TextAlign.center, style: TextStyles.caption(context: builderContext, color: theme.errorColor));
            } else if (state is ProfileNetworking) {
              return Text("getting profile information....",
                  textAlign: TextAlign.center, style: TextStyles.caption(context: builderContext, color: theme.hintColor));
            } else if (state is ProfileSuccess) {
              return Text(
                "all information is ready-to-use",
                textAlign: TextAlign.center,
                style: TextStyles.caption(context: builderContext, color: theme.successColor),
              );
            } else {
              return Text(
                "checking profile",
                textAlign: TextAlign.center,
                style: TextStyles.caption(context: builderContext, color: theme.hintColor),
              );
            }
          },
        );
      },
    );
  }
}
