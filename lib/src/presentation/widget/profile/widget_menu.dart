import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;

  ProfileMenu({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return ListTile(
          onTap: () {
            onTap();
          },
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Icon(icon, color: theme.primaryColor, size: 24)),
          ),
          title: Text(label, style: TextStyles.subTitle(context: context, color: theme.primaryColor)),
          trailing: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Icon(Icons.arrow_forward_ios_rounded, color: theme.shadowColor, size: 16)),
          ),
        );
      },
    );
  }
}
