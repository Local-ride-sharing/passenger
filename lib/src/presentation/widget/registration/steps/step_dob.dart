import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class DobStep extends StatefulWidget {
  final int dob;
  final Function(int) onSave;

  DobStep({
    required this.onSave,
    required this.dob,
  });

  @override
  _DobStepState createState() => _DobStepState();
}

class _DobStepState extends State<DobStep> {
  late int selectedDate;

  @override
  void initState() {
    selectedDate = widget.dob;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Date of birth",
                    style: TextStyles.caption(context: context, color: theme.textColor),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: theme.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  horizontalTitleGap: 8,
                  dense: true,
                  leading: Icon(Icons.event_outlined, color: theme.primaryColor),
                  title: Text(
                    DateFormat("dd MMMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(selectedDate)),
                    style: TextStyles.subTitle(context: context, color: theme.primaryColor),
                  ),
                  onTap: () async {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(selectedDate);
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1960, 1, 1),
                      lastDate: DateTime.now().subtract(Duration(days: 365 * 12)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate.millisecondsSinceEpoch;
                        widget.onSave(pickedDate.millisecondsSinceEpoch);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
