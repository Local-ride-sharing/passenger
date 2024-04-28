import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/presentation/shimmer/shimmer_label.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ShimmerDashboardVehicles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return GridView.builder(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          itemBuilder: (_, index) {
            return Container(
              decoration: BoxDecoration(
                color: theme.secondaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerLabel(
                    size: Size(
                      MediaQuery.of(context).size.width * .1,
                      MediaQuery.of(context).size.width * .1,
                    ),
                  ),
                  SizedBox(height: 4),
                  ShimmerLabel(size: Size(MediaQuery.of(context).size.width * .1, 12)),
                ],
              ),
            );
          },
          itemCount: 3,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
        );
      },
    );
  }
}
