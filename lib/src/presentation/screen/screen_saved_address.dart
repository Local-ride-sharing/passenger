import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:passenger/src/business_logic/address/delete_address_cubit.dart';
import 'package:passenger/src/business_logic/address/saved_address_list_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/data/model/saved_address.dart';
import 'package:passenger/src/data/provider/provider_profile.dart';
import 'package:passenger/src/presentation/widget/saved_address/widget_delete.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class SavedAddressListScreen extends StatefulWidget {
  final String route = "/saved_address_list";

  @override
  _SavedAddressListScreenState createState() => _SavedAddressListScreenState();
}

class _SavedAddressListScreenState extends State<SavedAddressListScreen> {
  late Passenger passenger;

  @override
  void initState() {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;
    BlocProvider.of<SavedAddressCubit>(context).monitorAddress(passenger.reference);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("Saved addresses", style: TextStyles.title(context: context, color: theme.textColor)),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 88,
                  child: BlocBuilder<SavedAddressCubit, SavedAddressState>(
                    builder: (context, state) {
                      if (state is SavedAddressError) {
                        return Center(child: Icon(Icons.error_outline));
                      } else if (state is SavedAddressNetworking) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is SavedAddressSuccess) {
                        final List<SavedAddress> savedAddresses = state.data;
                        return savedAddresses.isEmpty
                            ? Center(
                                child:
                                    Text("No data found", style: TextStyles.caption(context: context, color: theme.hintColor)))
                            : ListView.builder(
                                padding: EdgeInsets.all(0),
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (listContext, index) {
                                  final SavedAddress address = savedAddresses[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(
                                        address.addressType == AddressType.Home
                                            ? Icons.home
                                            : address.addressType == AddressType.Work
                                                ? Icons.work_outlined
                                                : Icons.public,
                                        color: theme.hintColor,
                                      ),
                                      backgroundColor: theme.secondaryColor,
                                    ),
                                    title: Text(address.label,
                                        style: TextStyles.subTitle(context: context, color: theme.primaryColor)),
                                    subtitle: Text(
                                        address.addressType == AddressType.Home
                                            ? "Home"
                                            : address.addressType == AddressType.Work
                                                ? "Work"
                                                : "Other",
                                        style: TextStyles.caption(context: context, color: theme.hintColor)),
                                    trailing: PopupMenuButton<String?>(
                                      color: theme.secondaryColor,
                                      elevation: 4,
                                      onSelected: (String? value) {
                                        switch (value) {
                                          case 'Edit':
                                            Navigator.pushNamed(context, AppRouter.editSavedAddress, arguments: address);
                                            break;
                                          case 'Delete':
                                            showDialog(
                                              context: context,
                                              barrierColor: theme.shadowColor,
                                              builder: (deleteContext) => BlocProvider(
                                                create: (context) => DeleteAddressCubit(),
                                                child: DeleteSavedAddressDialog(address.reference),
                                              ),
                                            );
                                            break;
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return ['Edit', 'Delete'].map((String? choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text(choice ?? ""),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  );
                                },
                                itemCount: savedAddresses.length,
                              );
                      } else {
                        return Center(child: Icon(Icons.error_rounded));
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.newSavedAddress);
                    },
                    child: Text(
                      "Add new address",
                      style: TextStyles.title(context: context, color: theme.textColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
