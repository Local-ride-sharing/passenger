import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ShimmerIcon extends StatelessWidget {
  final double width;
  final double height;

  ShimmerIcon(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return SizedBox(
          width: width,
          height: height,
          child: Shimmer.fromColors(
            baseColor: theme.shimmerBaseColor,
            highlightColor: theme.shimmerHighlightColor,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: theme.secondaryColor,
                borderRadius: BorderRadius.circular(width),
              ),
            ),
          ),
        );
      },
    );
  }
}
