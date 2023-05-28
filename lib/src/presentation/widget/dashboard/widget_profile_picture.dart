import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class DashboardProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final Passenger? profile = profileProvider.profile;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Container(
          width: 36,
          height: 36,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: theme.secondaryColor,
            borderRadius: BorderRadius.circular(36),
          ),
          child: profile != null && (profile.profilePicture ?? "").isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: profile.profilePicture ?? "",
                  fit: BoxFit.cover,
                  placeholder: (_, __) => ShimmerIcon(36, 36),
                  errorWidget: (_, __, ___) => Center(child: Icon(Icons.person_outline_rounded)),
                )
              : Center(child: Icon(Icons.person_outline_rounded)),
        );
      },
    );
  }
}
