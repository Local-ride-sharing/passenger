import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/point.dart';
import 'package:tmoto_passenger/src/presentation/widget/point_ride/pricing/widget_map.dart';
import 'package:tmoto_passenger/src/presentation/widget/point_ride/pricing/widget_pricing_widget.dart';
import 'package:tmoto_passenger/src/presentation/widget/widget_back_button.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class PointRidePricingAdDirection extends StatelessWidget {
  final Point point;

  PointRidePricingAdDirection(this.point);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Stack(
            children: [
              Positioned(
                child: RidePricingDirectionMapWidget(point),
                top: 0,
                right: 0,
                left: 0,
                bottom: 132,
              ),
              Positioned(
                child: BackButtonWidget(),
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
              ),
              Positioned(
                child: PointRidePricingWidget(point),
                left: 0,
                right: 0,
                bottom: 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
