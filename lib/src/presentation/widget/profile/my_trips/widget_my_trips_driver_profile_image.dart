import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:tmoto_passenger/src/data/model/driver.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_icon.dart';

class DriverProfilePic extends StatefulWidget {
  final Ride ride;

  DriverProfilePic(this.ride);

  @override
  _DriverProfilePicState createState() => _DriverProfilePicState();
}

class _DriverProfilePicState extends State<DriverProfilePic> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      BlocProvider.of<FindSingleDriverCubit>(context)
          .findDriver(context, widget.ride.driverReference ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
      ),
      child: BlocBuilder<FindSingleDriverCubit, FindSingleDriverState>(
        builder: (_, state) {
          if (state is FindSingleDriverNetworking) {
            return ShimmerIcon(24, 24);
          } else if (state is FindSingleDriverSuccess) {
            final Driver driver = state.data;
            return CachedNetworkImage(
              imageUrl: driver.profilePicture,
              fit: BoxFit.cover,
              width: 24,
              height: 24,
              placeholder: (_, __) => ShimmerIcon(24, 24),
              errorWidget: (_, __, ___) => Center(child: Icon(Icons.person_outline_rounded)),
            );
          } else {
            return Text("Not found");
          }
        },
      ),
    );
  }
}
