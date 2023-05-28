import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/address.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class VehiclePricing extends StatelessWidget {
  final Vehicle vehicle;
  final Vehicle? selection;
  final Address pickup;
  final Address destination;
  final Direction direction;
  final Function onTap;

  const VehiclePricing({
    required this.vehicle,
    required this.selection,
    required this.onTap,
    required this.direction,
    required this.pickup,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        final bool selected = vehicle.reference == (selection?.reference ?? "");

        return AspectRatio(
          aspectRatio: 1,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                  color: selected ? theme.accentColor : theme.secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.textColor.withOpacity(.025), width: 1)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: SvgPicture.network(
                        vehicle.image,
                        fit: BoxFit.contain,
                        height: 32,
                        width: 32,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        placeholderBuilder: (_) => ShimmerIcon(32, 32),
                      ),
                    ),
                    Text(vehicle.enName, style: TextStyles.caption(context: context, color: selected ? Colors.white60 : theme.hintColor).copyWith(fontSize: 10)),
                    const SizedBox(height: 8),
                    Text(
                      "৳ ${(vehicle.baseFare + (vehicle.perKmFare * direction.distance) + (vehicle.perMinuteFare * direction.duration)).ceilToDouble().toInt().toString()}",
                      style: TextStyles.subHeadline(context: context, color: selected ? Colors.white : theme.textColor).copyWith(fontSize: 20),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${direction.duration} min", style: TextStyles.caption(context: context, color: selected ? Colors.white60 : theme.hintColor).copyWith(fontSize: 10)),
                        const SizedBox(width: 4),
                        Icon(Icons.circle, color: selected ? Colors.white60 : theme.shadowColor, size: 4),
                        const SizedBox(width: 4),
                        Text("${direction.distance.toStringAsFixed(2)} km", style: TextStyles.caption(context: context, color: selected ? Colors.white60 : theme.hintColor).copyWith(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
