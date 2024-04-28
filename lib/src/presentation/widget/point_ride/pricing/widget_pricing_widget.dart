import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/point.dart';
import 'package:passenger/src/data/model/vehicle.dart';
import 'package:passenger/src/data/provider/provider_vehicle.dart';
import 'package:passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class PointRidePricingWidget extends StatelessWidget {
  final Point point;

  PointRidePricingWidget(this.point);

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final Vehicle vehicle = vehicleProvider.get(point.vehicleReference)!;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 7,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.network(
                    vehicle.image,
                    fit: BoxFit.cover,
                    width: 36,
                    height: 36,
                    excludeFromSemantics: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    placeholderBuilder: (_) =>
                        ShimmerIcon(MediaQuery.of(context).size.width * .1, MediaQuery.of(context).size.width * .1),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${point.duration}min",
                    style: TextStyles.caption(context: context, color: theme.hintColor),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${point.distance.toStringAsFixed(2)}km",
                    style: TextStyles.caption(context: context, color: theme.hintColor),
                  ),
                  SizedBox(height: 8),
                  Text("৳ ${point.baseFare}", style: TextStyles.subTitle(context: context, color: theme.textColor)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
