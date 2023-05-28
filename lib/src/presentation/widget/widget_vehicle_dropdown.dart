import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/presentation/widget/widget_vehicle_dropdown_selector.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class VehicleDropdown extends StatelessWidget {
  final Vehicle? value;
  final List<Vehicle> items;
  final bool? shouldValidate;
  final Function(Vehicle) onSelect;
  final bool? validationFlag;

  VehicleDropdown({
    required this.value,
    required this.items,
    required this.onSelect,
    this.shouldValidate,
    this.validationFlag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeProvider = ThemeHelper(state.value);
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.redShade,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text(value == null ? "Select one" : value?.enName ?? "",
                style: TextStyles.body(context: context, color: themeProvider.textColor)),
            trailing: Icon(Icons.arrow_drop_down, color: themeProvider.textColor),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => VehicleDropdownSelector(
                          value: value,
                          items: items,
                          onSelect: (value) {
                            onSelect(value);
                          },
                        ),
                    fullscreenDialog: true),
              );
            },
          ),
        );
      },
    );
  }
}
