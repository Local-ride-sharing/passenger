import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/address/delete_address_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class DeleteSavedAddressDialog extends StatelessWidget {
  final String reference;

  DeleteSavedAddressDialog(this.reference);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: theme.isDark ? theme.secondaryColor : theme.backgroundColor,
          title: Text("Delete", style: TextStyles.title(context: context, color: theme.errorColor)),
          content: Text("Are you sure?", style: TextStyles.body(context: context, color: theme.textColor)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: theme.errorColor,
                shadowColor: theme.shadowColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: theme.errorColor, width: 3),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyles.subTitle(context: context, color: theme.errorColor)),
            ),
            BlocConsumer<DeleteAddressCubit, DeleteAddressState>(
              listener: (_, state) {
                if (state is DeleteAddressSuccess) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierColor: theme.shadowColor,
                    builder: (deleteContext) => AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: theme.isDark ? theme.secondaryColor : theme.backgroundColor,
                      title: Text("Confirmation", style: TextStyles.title(context: context, color: theme.primaryColor)),
                      content: Text("Address deleted successfully",
                          style: TextStyles.body(context: context, color: theme.textColor)),
                    ),
                  );
                }
              },
              builder: (_, state) {
                if (state is DeleteAddressError) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.errorColor,
                      elevation: 3,
                      shadowColor: theme.hintColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      BlocProvider.of<DeleteAddressCubit>(context).deleteAddress(reference);
                    },
                    child: Text("Try again", style: TextStyles.subTitle(context: context, color: theme.backgroundColor)),
                  );
                } else if (state is DeleteAddressNetworking) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.errorColor,
                      elevation: 3,
                      shadowColor: theme.hintColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Container(
                        width: 64,
                        child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)))),
                  );
                } else if (state is DeleteAddressSuccess) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.errorColor,
                      elevation: 3,
                      shadowColor: theme.hintColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Text("Deleted", style: TextStyles.subTitle(context: context, color: theme.backgroundColor)),
                  );
                } else {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.errorColor,
                      elevation: 3,
                      shadowColor: theme.hintColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      BlocProvider.of<DeleteAddressCubit>(context).deleteAddress(reference);
                    },
                    child: Text("Yes, Delete", style: TextStyles.subTitle(context: context, color: theme.backgroundColor)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
