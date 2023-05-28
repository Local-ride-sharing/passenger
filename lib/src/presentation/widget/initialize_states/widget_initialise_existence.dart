import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/login/existence_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class InitialiseExistenceWidget extends StatelessWidget {
  final Widget child;

  InitialiseExistenceWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<ExistenceCubit, ExistenceState>(
          builder: (builderContext, state) {
            if (state is ExistenceError) {
              return Text(state.error,
                  textAlign: TextAlign.center, style: TextStyles.caption(context: builderContext, color: theme.errorColor));
            } else if (state is ExistenceNetworking) {
              return Text("finding profile....",
                  textAlign: TextAlign.center, style: TextStyles.caption(context: builderContext, color: theme.hintColor));
            } else if (state is ExistenceSuccess) {
              return child;
            } else {
              return Text("checking authentication",
                  textAlign: TextAlign.center, style: TextStyles.caption(context: builderContext, color: theme.hintColor));
            }
          },
        );
      },
    );
  }
}
