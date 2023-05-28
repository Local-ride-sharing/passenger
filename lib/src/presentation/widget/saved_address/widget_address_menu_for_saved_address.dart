import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class AddressMenuForSavedAddress extends StatelessWidget {
  final AddressType type;
  final AddressType selection;
  final Function(AddressType) onTap;

  AddressMenuForSavedAddress({required this.type, required this.selection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      final theme = ThemeHelper(state.value);
      return InkWell(
        onTap: () {
          onTap(type);
        },
        child: Column(
          children: [
            CircleAvatar(
              child: Icon(
                type == AddressType.Home
                    ? Icons.home
                    : type == AddressType.Work
                        ? Icons.work_outlined
                        : Icons.public,
                color: type == selection ? theme.backgroundColor : theme.hintColor,
                size: 24,
              ),
              backgroundColor: type == selection ? theme.primaryColor : theme.secondaryColor,
              radius: 24,
            ),
            SizedBox(height: 8),
            Text(
              type == AddressType.Home
                  ? "Home"
                  : type == AddressType.Work
                      ? "Work"
                      : "Other",
              style: TextStyles.caption(
                  context: context,
                  color: type == selection ? theme.primaryColor : theme.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }
}
