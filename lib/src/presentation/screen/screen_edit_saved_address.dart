import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/address/update_address_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/instant_ride/widget_address_text_field_for_address_picker.dart';
import 'package:passenger/src/presentation/widget/saved_address/widget_address_menu_for_saved_address.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class EditSavedAddressScreen extends StatefulWidget {
  final String route = "/edit_address";

  final SavedAddress savedAddress;

  EditSavedAddressScreen(this.savedAddress);

  @override
  _EditSavedAddressScreenState createState() => _EditSavedAddressScreenState();
}

class _EditSavedAddressScreenState extends State<EditSavedAddressScreen> {
  late AddressType addressType;
  late Passenger passenger;

  String label = "";

  double latitude = 0;

  double longitude = 0;

  @override
  void initState() {
    label = widget.savedAddress.label;
    latitude = widget.savedAddress.latitude;
    longitude = widget.savedAddress.longitude;
    addressType = widget.savedAddress.addressType;
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;
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
              backgroundColor: theme.backgroundColor,
              automaticallyImplyLeading: true,
              elevation: 0,
              title: Text(
                "Update address",
                style: TextStyles.title(context: context, color: theme.textColor),
              ),
              centerTitle: false,
            ),
            body: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.backgroundColor),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddressTextFieldForAddressPicker(
                          icon: Icons.my_location,
                          address: Address(label: label, latitude: latitude, longitude: longitude),
                          hint: "address",
                          onFinish: (address) {
                            setState(() {
                              label = address.label;
                              latitude = address.latitude;
                              longitude = address.longitude;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AddressMenuForSavedAddress(
                              type: AddressType.Home,
                              selection: addressType,
                              onTap: (type) {
                                setState(() {
                                  addressType = type;
                                });
                              },
                            ),
                            SizedBox(width: 24),
                            AddressMenuForSavedAddress(
                              type: AddressType.Work,
                              selection: addressType,
                              onTap: (type) {
                                setState(() {
                                  addressType = type;
                                });
                              },
                            ),
                            SizedBox(width: 24),
                            AddressMenuForSavedAddress(
                              type: AddressType.Other,
                              selection: addressType,
                              onTap: (type) {
                                setState(() {
                                  addressType = type;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BlocConsumer<UpdateAddressCubit, UpdateAddressState>(
                      listener: (BuildContext context, state) {
                        if (state is UpdateAddressError) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text("Update error", style: TextStyles.subTitle(context: context, color: theme.errorColor)),
                              content: Text(state.error, style: TextStyles.body(context: context, color: theme.errorColor)),
                            ),
                          );
                        } else if (state is UpdateAddressSuccess) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Updated successfully",
                                  style: TextStyles.subTitle(context: context, color: theme.primaryColor)),
                              content: Text("Address updated successfully",
                                  style: TextStyles.body(context: context, color: theme.primaryColor)),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is UpdateAddressNetworking) {
                          return ElevatedButton(
                            child: Text("Updating...".toUpperCase(),
                                style: TextStyles.title(context: context, color: theme.textColor)),
                            onPressed: () {},
                          );
                        } else if (state is UpdateAddressError) {
                          return ElevatedButton(
                            child: Text("Failed to update".toUpperCase(),
                                style: TextStyles.title(context: context, color: theme.textColor)),
                            onPressed: label.isEmpty
                                ? null
                                : () {
                                    final SavedAddress address = SavedAddress(
                                      widget.savedAddress.reference,
                                      passenger.reference,
                                      addressType,
                                      label,
                                      latitude,
                                      longitude,
                                    );
                                    BlocProvider.of<UpdateAddressCubit>(context).updateAddress(address);
                                  },
                          );
                        } else if (state is UpdateAddressSuccess) {
                          return ElevatedButton(
                            child: Text("Updated".toUpperCase(),
                                style: TextStyles.title(context: context, color: theme.textColor)),
                            onPressed: () {},
                          );
                        } else {
                          return ElevatedButton(
                            child:
                                Text("Update".toUpperCase(), style: TextStyles.title(context: context, color: theme.textColor)),
                            onPressed: label.isEmpty
                                ? null
                                : () {
                                    final SavedAddress address = SavedAddress(
                                      widget.savedAddress.reference,
                                      passenger.reference,
                                      addressType,
                                      label,
                                      latitude,
                                      longitude,
                                    );
                                    BlocProvider.of<UpdateAddressCubit>(context).updateAddress(address);
                                  },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
