import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ThemeMenuItem extends StatelessWidget {
  final int value;
  final String label;

  ThemeMenuItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return ListTile(
          leading: Icon(
            state.value == value ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
            color: state.value == value ? theme.primaryColor : theme.hintColor,
          ),
          title: Text(
            label,
            style: TextStyles.body(context: context, color: state.value == value ? theme.primaryColor : theme.hintColor),
          ),
          onTap: () {
            ThemeHelper(value);
            BlocProvider.of<ThemeCubit>(context).changeTheme(value);
          },
        );
      },
    );
  }
}
