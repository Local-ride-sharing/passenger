import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class FindDriverNetworkingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Stack(
          children: [
            Positioned(
              child: Container(
                decoration: BoxDecoration(color: theme.backgroundColor.withOpacity(.5)),
              ),
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
            ),
            Center(
              child: Lottie.asset("assets/search.json"),
            ),
          ],
        );
      },
    );
  }
}
