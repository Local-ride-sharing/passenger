import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/vehicle.dart';
import 'package:passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class VehicleDropdownSelector extends StatelessWidget {
  final Vehicle? value;
  final List<Vehicle> items;
  final Function(Vehicle) onSelect;

  VehicleDropdownSelector({required this.value, required this.items, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeProvider = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.backgroundColor,
            automaticallyImplyLeading: true,
            title: Text("Select a vehicle", style: TextStyles.subHeadline(context: context, color: themeProvider.primaryColor)),
            elevation: 0,
          ),
          body: ListView.builder(
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final Vehicle item = items[index];
              return ListTile(
                onTap: () {
                  onSelect(item);
                  Navigator.of(context).pop();
                },
                leading: SizedBox(
                  width: 36,
                  height: 36,
                  child: SvgPicture.network(
                    item.image,
                    fit: BoxFit.contain,
                    width: 36,
                    height: 36,
                    cacheColorFilter: true,
                    excludeFromSemantics: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    placeholderBuilder: (_) => ShimmerIcon(36, 36),
                  ),
                ),
                title: Text((item.enName).trim(),
                    style: TextStyles.body(
                      context: context,
                      color: value?.reference == item.reference ? themeProvider.primaryColor : themeProvider.textColor,
                    )),
                trailing: Icon(
                  value?.reference == item.reference ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: value?.reference == item.reference ? themeProvider.primaryColor : themeProvider.textColor,
                ),
                dense: false,
                visualDensity: VisualDensity.comfortable,
                contentPadding: EdgeInsets.zero,
              );
            },
            itemCount: items.length,
          ),
        );
      },
    );
  }
}
