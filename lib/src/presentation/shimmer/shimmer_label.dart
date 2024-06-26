import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ShimmerLabel extends StatelessWidget {
  final Size size;

  ShimmerLabel({required this.size});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Shimmer.fromColors(
            baseColor: theme.shimmerBaseColor,
            highlightColor: theme.shimmerHighlightColor,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: theme.secondaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }
}
