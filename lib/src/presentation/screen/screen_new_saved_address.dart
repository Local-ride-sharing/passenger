import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/address/create_address_cubit.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/data/model/current_location.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/instant_ride/widget_address_text_field_for_address_picker.dart';
import 'package:passenger/src/presentation/widget/saved_address/widget_address_menu_for_saved_address.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/helper.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class NewSavedAddressScreen extends StatefulWidget {
  @override
  _NewSavedAddressScreenState createState() => _NewSavedAddressScreenState();
}

class _NewSavedAddressScreenState extends State<NewSavedAddressScreen> {
  late AddressType addressType = AddressType.Home;
  late Passenger passenger;
  String label = "";
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    final CurrentLocation location = BlocProvider.of<LocationCubit>(context).state;
    Helper.findAddress(location.latitude, location.longitude).then((value) {
      if (value != null) {
        setState(() {
          label = value.label;
          latitude = value.latitude;
          longitude = value.longitude;
        });
      }
    });

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
              automaticallyImplyLeading: true,
              title: Text(
                "New address",
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
                    child: BlocConsumer<CreateAddressCubit, CreateAddressState>(
                      listener: (context, state) {
                        if (state is CreateAddressSuccess) {
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        if (state is CreateAddressError) {
                          return ElevatedButton(
                            onPressed: label.isEmpty
                                ? null
                                : () {
                                    final SavedAddress address = SavedAddress(
                                      "",
                                      passenger.reference,
                                      addressType,
                                      label,
                                      latitude,
                                      longitude,
                                    );
                                    BlocProvider.of<CreateAddressCubit>(context).createAddress(address);
                                  },
                            child: Text(
                              "Retry",
                              style: TextStyles.title(context: context, color: theme.textColor),
                            ),
                          );
                        } else if (state is CreateAddressNetworking) {
                          return ElevatedButton(
                            onPressed: () {},
                            child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
                          );
                        } else if (state is CreateAddressSuccess) {
                          return ElevatedButton(
                            onPressed: () {},
                            child: Center(child: Icon(Icons.check, color: theme.textColor)),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: label.isEmpty
                                ? null
                                : () {
                                    final SavedAddress address = SavedAddress(
                                      "",
                                      passenger.reference,
                                      addressType,
                                      label,
                                      latitude,
                                      longitude,
                                    );
                                    BlocProvider.of<CreateAddressCubit>(context).createAddress(address);
                                  },
                            child: Text(
                              "Save address",
                              style: TextStyles.title(context: context, color: theme.textColor),
                            ),
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
