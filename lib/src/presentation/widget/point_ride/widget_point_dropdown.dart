import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/point.dart';
import 'package:tmoto_passenger/src/presentation/widget/point_ride/widget_product_dropdown_selector.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class PointDropdown extends StatelessWidget {
  final Point? value;
  final String title;
  final String text;
  final List<Point> items;
  final Function(Point) onSelect;

  PointDropdown({
    required this.value,
    required this.text,
    required this.title,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return TextButton(
          style: TextButton.styleFrom(
              primary: theme.accentColor,
              backgroundColor: theme.secondaryColor,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: SizedBox(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 24,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: value == null
                        ? Text(
                            "Select one",
                            style: TextStyles.body(context: context, color: theme.textColor),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                horizontalTitleGap: 0,
                                leading: Icon(Icons.hail, color: theme.iconColor),
                                title: Text(value?.enPickup.label ?? "",
                                    style:
                                        TextStyles.body(context: context, color: theme.textColor)),
                              ),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                horizontalTitleGap: 0,
                                leading: Icon(Icons.tour_rounded, color: theme.iconColor),
                                title: Text(
                                  value?.enDestination.label ?? "",
                                  style: TextStyles.body(context: context, color: theme.textColor),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: value == null
                      ? Icon(Icons.arrow_drop_down, color: theme.hintColor)
                      : Center(
                          child: Text("৳ ${value?.baseFare.toString() ?? ""}",
                              style: TextStyles.caption(context: context, color: theme.hintColor)),
                        ),
                )
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: value != null ? 64 : 16,
          ),
          onPressed: items.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PointDropdownSelector(
                              value: value,
                              title: title,
                              items: items,
                              onSelect: (value) {
                                onSelect(value);
                              },
                            ),
                        fullscreenDialog: true),
                  );
                },
        );
      },
    );
  }
}
