import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/passenger/update_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/upload/upload_cubit.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/presentation/shimmer/shimmer_icon.dart';
import 'package:tmoto_passenger/src/presentation/widget/edit_profile/widget_save_states.dart';
import 'package:tmoto_passenger/src/presentation/widget/edit_profile/widget_upload_states.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? path;
  late String imageUrl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  late Gender gender;
  late String reference;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final Passenger passenger = profileProvider.profile!;
    imageUrl = passenger.profilePicture ?? "";
    nameController.text = passenger.name;
    reference = passenger.reference;
    gender = passenger.gender;
    dateOfBirthController.text = DateFormat("dd MMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(passenger.dob));
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final Passenger passenger = profileProvider.profile!;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            automaticallyImplyLeading: true,
            elevation: 0,
            title: Text("Update profile", style: TextStyles.title(context: context, color: theme.textColor)),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Positioned(
                          child: Container(
                        width: 144,
                        height: 144,
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(144),
                          boxShadow: [
                            BoxShadow(
                              color: theme.secondaryColor,
                              blurRadius: 4,
                              spreadRadius: 4,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () async {
                            final XFile? file =
                                await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, maxHeight: 1024, maxWidth: 1024);
                            if (file != null) {
                              setState(() {
                                path = file.path;
                              });
                            }
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          child: path != null
                              ? Image.file(File(path ?? ""), fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => ShimmerIcon(144, 144),
                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.person_rounded, color: theme.hintColor, size: 42)),
                                ),
                        ),
                      )),
                      Positioned(
                          right: 8,
                          top: 4,
                          child: InkWell(
                            onTap: () async {
                              final XFile? file =
                                  await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, maxHeight: 1024, maxWidth: 1024);
                              if (file != null) {
                                setState(() {
                                  path = file.path;
                                });
                              }
                            },
                            child: CircleAvatar(backgroundColor: theme.backgroundColor, maxRadius: 16, child: Icon(MdiIcons.camera, color: theme.iconColor, size: 24)),
                          ))
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyles.body(context: context, color: theme.textColor),
                    onChanged: (val) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.secondaryColor,
                      isDense: true,
                      labelText: "Full name *",
                      labelStyle: TextStyles.caption(context: context, color: theme.primaryColor),
                      hintText: "ex - John doe",
                      hintStyle: TextStyles.body(context: context, color: theme.hintColor),
                      errorStyle: TextStyles.caption(context: context, color: theme.errorColor).copyWith(fontSize: 9, height: 1),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor, width: 4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      errorText: null,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.errorColor, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.errorColor, width: 4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: dateOfBirthController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyles.body(context: context, color: theme.textColor),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTap: () async {
                      final DateTime initialDate = DateFormat("dd MMM, yyyy").parse(dateOfBirthController.text);
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(1960, 1, 1),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateOfBirthController.text = DateFormat("dd MMM, yyyy").format(pickedDate);
                        });
                      }
                    },
                    enabled: true,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.secondaryColor,
                      isDense: true,
                      labelText: "Date of birth *",
                      labelStyle: TextStyles.caption(context: context, color: theme.primaryColor),
                      hintText: "ex - 01 Jan, 2000",
                      hintStyle: TextStyles.body(context: context, color: theme.hintColor),
                      errorStyle: TextStyles.caption(context: context, color: theme.errorColor).copyWith(fontSize: 9, height: 1),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primaryColor, width: 4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      errorText: null,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.errorColor, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.errorColor, width: 4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(alignment: Alignment.centerLeft, child: Text("Gender", style: TextStyles.caption(context: context, color: theme.hintColor))),
                  SizedBox(height: 4),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: CupertinoSlidingSegmentedControl<Gender>(
                      groupValue: gender,
                      children: {
                        Gender.male: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Male", style: TextStyles.subTitle(context: context, color: theme.textColor)),
                        ),
                        Gender.female: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Female", style: TextStyles.subTitle(context: context, color: theme.textColor)),
                        ),
                        Gender.other: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Other", style: TextStyles.subTitle(context: context, color: theme.textColor)),
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          gender = value ?? Gender.other;
                        });
                      },
                      thumbColor: theme.backgroundColor,
                      backgroundColor: theme.secondaryColor,
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  SizedBox(height: 42),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: MultiBlocListener(
                      listeners: [
                        BlocListener<UploadCubit, UploadState>(
                          listener: (context, state) {
                            if (state is UploadSuccess) {
                              imageUrl = state.data;
                              passenger.name = nameController.text;
                              passenger.gender = gender;
                              passenger.dob = DateFormat("dd MMM, yyyy").parse(dateOfBirthController.text).millisecondsSinceEpoch;
                              passenger.profilePicture = imageUrl;
                              BlocProvider.of<UpdateCubit>(context).update(passenger);
                            }
                          },
                        ),
                        BlocListener<UpdateCubit, UpdateState>(
                          listener: (context, state) {
                            if (state is UpdateSuccess) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                      child: (path ?? "").isNotEmpty
                          ? UploadStatesForEditProfile(
                              path: path ?? "",
                              reference: reference,
                              child: SaveStatesForEditProfile(
                                reference: reference,
                                name: nameController.text,
                                gender: gender,
                                phone: passenger.phone,
                                dob: DateFormat("dd MMM, yyyy").parse(dateOfBirthController.text).millisecondsSinceEpoch,
                                imageUrl: imageUrl,
                              ),
                            )
                          : SaveStatesForEditProfile(
                              name: nameController.text,
                              gender: gender,
                              reference: reference,
                              phone: passenger.phone,
                              dob: DateFormat("dd MMM, yyyy").parse(dateOfBirthController.text).millisecondsSinceEpoch,
                              imageUrl: imageUrl,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
