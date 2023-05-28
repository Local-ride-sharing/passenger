import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class VehicleMenu extends StatelessWidget {
  final Vehicle vehicle;
  final Function onTap;

  VehicleMenu({required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return InkWell(
          onTap: () {
            onTap();
          },
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: PhysicalModel(
            color: theme.backgroundColor,
            shadowColor: theme.backgroundColor,
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
                    height: 24,
                    width: 36,
                    child: SvgPicture.network(
                      vehicle.image,
                      fit: BoxFit.contain,
                      width: 36,
                      height: 24,
                      placeholderBuilder: (_) => ShimmerIcon(MediaQuery.of(context).size.width * .1,
                          MediaQuery.of(context).size.width * .1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(vehicle.enName,
                      style: TextStyles.caption(context: context, color: theme.textColor)
                          .copyWith(fontSize: 10))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
