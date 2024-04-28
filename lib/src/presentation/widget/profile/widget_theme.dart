import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/presentation/widget/profile/widget_theme_menu_item.dart';
import 'package:passenger/src/utils/constants.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return PhysicalModel(
          color: theme.isDark ? theme.secondaryColor : theme.backgroundColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Change theme", style: TextStyles.title(context: context, color: theme.primaryColor)),
                ),
                Divider(),
                ThemeMenuItem(ThemeValue.systemPreferred, "System preferred"),
                ThemeMenuItem(ThemeValue.light, "Light"),
                ThemeMenuItem(ThemeValue.dark, "Dark"),
              ],
            ),
          ),
        );
      },
    );
  }
}
