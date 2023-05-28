import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class GenderStep extends StatefulWidget {
  final Gender gender;
  final Function(Gender) onSave;

  GenderStep({
    required this.gender,
    required this.onSave,
  });

  @override
  _GenderStepState createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  late Gender selection;

  @override
  void initState() {
    selection = widget.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  "Choose your gender *",
                  style: TextStyles.caption(context: context, color: theme.textColor),
                ),
              ),
              ListTile(
                dense: true,
                horizontalTitleGap: 8,
                leading: Icon(
                  selection == Gender.male ? MdiIcons.radioboxMarked : MdiIcons.radioboxBlank,
                  color: selection == Gender.male ? theme.primaryColor : theme.hintColor,
                ),
                title: Text("Male",
                    style: TextStyles.subTitle(context: context, color: theme.textColor)),
                onTap: () {
                  setState(() {
                    selection = Gender.male;
                    widget.onSave(selection);
                  });
                },
              ),
              ListTile(
                dense: true,
                horizontalTitleGap: 8,
                leading: Icon(
                  selection == Gender.female ? MdiIcons.radioboxMarked : MdiIcons.radioboxBlank,
                  color: selection == Gender.female ? theme.primaryColor : theme.hintColor,
                ),
                title: Text("Female",
                    style: TextStyles.subTitle(context: context, color: theme.textColor)),
                onTap: () {
                  setState(() {
                    selection = Gender.female;
                    widget.onSave(selection);
                  });
                },
              ),
              ListTile(
                dense: true,
                horizontalTitleGap: 8,
                leading: Icon(
                  selection == Gender.other ? MdiIcons.radioboxMarked : MdiIcons.radioboxBlank,
                  color: selection == Gender.other ? theme.primaryColor : theme.hintColor,
                ),
                title: Text("Other",
                    style: TextStyles.subTitle(context: context, color: theme.textColor)),
                onTap: () {
                  setState(() {
                    selection = Gender.other;
                    widget.onSave(selection);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
