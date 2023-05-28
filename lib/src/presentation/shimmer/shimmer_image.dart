import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class ShimmerImage extends StatelessWidget {
  final Size size;

  ShimmerImage({required this.size});

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
              child: Center(child: Icon(Icons.image_outlined, color: theme.shadowColor)),
            ),
          ),
        );
      },
    );
  }
}
