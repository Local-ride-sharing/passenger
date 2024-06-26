import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/address/saved_address_list_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/presentation/widget/widget_location_point_picker.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class AddressPicker extends StatelessWidget {
  final IconData icon;
  final Address? address;
  final String hint;
  final bool? showSavedAddresses;
  final Function(Address) onFinish;

  AddressPicker(
      {required this.icon, required this.address, required this.hint, required this.onFinish, this.showSavedAddresses});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return InkWell(
          onTap: () {
            if (showSavedAddresses ?? false) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => SavedAddressCubit(),
                    child: LocationPointPicker(
                      address: address,
                      showSavedAddresses: showSavedAddresses,
                      onFinish: (val) {
                        onFinish(val);
                      },
                    ),
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LocationPointPicker(
                    address: address,
                    showSavedAddresses: showSavedAddresses,
                    onFinish: (val) {
                      onFinish(val);
                    },
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(icon, color: theme.textColor),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    address?.label ?? hint,
                    style: TextStyles.caption(
                      context: context,
                      color: address?.label == null ? theme.hintColor : theme.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
