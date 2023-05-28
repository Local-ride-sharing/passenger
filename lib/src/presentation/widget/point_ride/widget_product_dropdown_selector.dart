import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/point.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

// ignore: must_be_immutable
class PointDropdownSelector extends StatefulWidget {
  Point? value;
  final String title;
  final List<Point> items;
  final Function(Point) onSelect;

  PointDropdownSelector(
      {required this.value, required this.title, required this.items, required this.onSelect});

  @override
  _PointDropdownSelectorState createState() => _PointDropdownSelectorState();
}

class _PointDropdownSelectorState extends State<PointDropdownSelector> {
  final TextEditingController searchController = TextEditingController();

  List<Point> list = [];

  @override
  void initState() {
    list = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(widget.title,
                style: TextStyles.title(context: context, color: theme.textColor)),
            backgroundColor: theme.backgroundColor,
            centerTitle: false,
            elevation: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  keyboardType: TextInputType.name,
                  style: TextStyles.body(context: context, color: theme.textColor),
                  cursorColor: theme.accentColor,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    setState(() {
                      list = widget.items
                          .where((element) =>
                              element.enPickup.label.toLowerCase().contains(value.toLowerCase()) ||
                              element.enDestination.label
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: theme.secondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.all(16),
                    hintText: "search",
                    hintStyle: TextStyles.body(context: context, color: theme.hintColor),
                    helperStyle: TextStyles.caption(context: context, color: theme.errorColor),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: ScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    final Point item = list[index];
                    return InkWell(
                      onTap: () {
                        widget.onSelect(item);
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            horizontalTitleGap: 0,
                            leading: Icon(Icons.hail, color: theme.iconColor),
                            title: Text(item.enPickup.label,
                                style: TextStyles.body(context: context, color: theme.textColor)),
                            trailing: Text("৳ ${item.baseFare}",
                                style: TextStyles.body(context: context, color: theme.textColor)),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            horizontalTitleGap: 0,
                            leading: Icon(Icons.tour_rounded, color: theme.iconColor),
                            title: Text(item.enDestination.label,
                                style: TextStyles.body(context: context, color: theme.textColor)),
                            trailing: Text("${item.distance.toStringAsFixed(2)} km",
                                style:
                                    TextStyles.caption(context: context, color: theme.hintColor)),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
