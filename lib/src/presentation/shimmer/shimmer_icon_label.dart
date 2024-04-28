import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ShimmerIconLabel extends StatelessWidget {
  final double iconSize;
  final Size label;
  final double gap;

  ShimmerIconLabel({required this.iconSize, required this.label, required this.gap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: Shimmer.fromColors(
                baseColor: theme.shimmerBaseColor,
                highlightColor: theme.shimmerHighlightColor,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: theme.secondaryColor,
                    borderRadius: BorderRadius.circular(iconSize),
                  ),
                ),
              ),
            ),
            SizedBox(width: gap),
            SizedBox(
              width: label.width,
              height: label.height,
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
            ),
          ],
        );
      },
    );
  }
}
