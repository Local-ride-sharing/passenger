import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/provider/provider_vehicle.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class PriceBreakdownWidget extends StatefulWidget {
  final Ride ride;

  PriceBreakdownWidget(this.ride);

  @override
  State<PriceBreakdownWidget> createState() => _PriceBreakdownWidgetState();
}

class _PriceBreakdownWidgetState extends State<PriceBreakdownWidget> {
  @override
  void initState() {
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    vehicle = vehicleProvider.get(widget.ride.vehicleReference)!;
    super.initState();
  }

  late Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                title: Text("Base fare", style: TextStyles.caption(context: context, color: theme.textColor)),
                trailing: Text(
                  "৳ ${vehicle.baseFare.toStringAsFixed(1)}",
                  style: TextStyles.caption(context: context, color: theme.textColor),
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                title: Text("Distance fare", style: TextStyles.caption(context: context, color: theme.textColor)),
                trailing: Text(
                  "৳ ${(vehicle.perKmFare * widget.ride.distance).toStringAsFixed(2)}",
                  style: TextStyles.caption(context: context, color: theme.textColor),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${widget.ride.distance.toStringAsFixed(1)} km", style: TextStyles.caption(context: context, color: theme.hintColor)),
                    SizedBox(width: 4),
                    Icon(Icons.circle, size: 9, color: theme.hintColor),
                    SizedBox(width: 4),
                    Text("৳ ${vehicle.perKmFare}", style: TextStyles.caption(context: context, color: theme.hintColor))
                  ],
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                title: Text("Duration fare", style: TextStyles.caption(context: context, color: theme.textColor)),
                trailing: Text(
                  "৳ ${(vehicle.perMinuteFare * widget.ride.duration).toStringAsFixed(2)}",
                  style: TextStyles.caption(context: context, color: theme.textColor),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${widget.ride.duration.toStringAsFixed(1)} min", style: TextStyles.caption(context: context, color: theme.hintColor)),
                    SizedBox(width: 4),
                    Icon(Icons.circle, size: 9, color: theme.hintColor),
                    SizedBox(width: 4),
                    Text("৳ ${vehicle.perMinuteFare}", style: TextStyles.caption(context: context, color: theme.hintColor))
                  ],
                ),
              ),
              Visibility(
                visible: vehicle.minimumFare > widget.ride.fare,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  title: Text("Minimum fare", style: TextStyles.caption(context: context, color: theme.textColor)),
                  trailing: Text(
                    "৳ ${(vehicle.minimumFare).toStringAsFixed(2)}",
                    style: TextStyles.caption(context: context, color: theme.textColor),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                title: Text("Total fare", style: TextStyles.subTitle(context: context, color: theme.textColor)),
                trailing: Text(
                  "৳ ${widget.ride.fare}",
                  style: TextStyles.subTitle(context: context, color: theme.textColor),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("I understand", style: TextStyles.title(context: context, color: theme.textColor)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
