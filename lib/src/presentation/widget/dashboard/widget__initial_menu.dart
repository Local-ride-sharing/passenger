import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class DashboardMenu extends StatelessWidget {
  final String image;
  final String name;
  final String route;
  final bool isAmbulance;

  DashboardMenu({
    required this.image,
    required this.name,
    required this.route,
    this.isAmbulance = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return IconButton(
          onPressed: () {
            if (isAmbulance) {
              Navigator.of(context).pushNamed(route, arguments: isAmbulance);
            } else {
              Navigator.of(context).pushNamed(route);
            }
          },
          icon: PhysicalModel(
            color: theme.backgroundColor,
            shadowColor: theme.secondaryColor,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 3,
            child: AspectRatio(
              aspectRatio: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: Image.asset(image, fit: BoxFit.contain, width: 48, height: 48),
                  ),
                  SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyles.caption(context: context, color: theme.textColor)
                        .copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
