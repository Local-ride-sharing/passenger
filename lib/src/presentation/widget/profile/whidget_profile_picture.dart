import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ProfilePictureWidget extends StatelessWidget {
  final Passenger passenger;

  ProfilePictureWidget(this.passenger);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return FittedBox(
          alignment: Alignment.centerLeft,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: theme.secondaryColor,
                maxRadius: 64,
                child: Container(
                  margin: EdgeInsets.all(8),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(128),
                  ),
                  child: (passenger.profilePicture ?? "").isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: passenger.profilePicture ?? "",
                          fit: BoxFit.cover,
                          width: 124,
                          height: 124,
                          placeholder: (context, url) => ShimmerIcon(124, 124),
                          errorWidget: (context, url, error) =>
                              Center(child: Icon(Icons.person_rounded, color: theme.hintColor, size: 42)),
                        )
                      : Center(child: Icon(Icons.person_rounded, color: theme.hintColor, size: 42)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
