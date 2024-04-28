import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:passenger/src/business_logic/registration/registration_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/business_logic/upload/upload_cubit.dart';
import 'package:passenger/src/data/model/passenger.dart';
import 'package:passenger/src/presentation/widget/registration/widget_registration_states.dart';
import 'package:passenger/src/presentation/widget/registration/widget_upload_states.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class FinishStep extends StatefulWidget {
  final String reference;
  final String name;
  final int dateOfBirth;
  final String phone;
  final Gender gender;
  final String? filePath;

  FinishStep(
      {required this.name,
      required this.reference,
      required this.dateOfBirth,
      required this.phone,
      required this.gender,
      required this.filePath});

  @override
  _FinishStepState createState() => _FinishStepState();
}

class _FinishStepState extends State<FinishStep> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.width * .5,
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .5),
                      boxShadow: [
                        BoxShadow(
                          color: theme.secondaryColor,
                          blurRadius: 8,
                          spreadRadius: 8,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: widget.filePath != null
                        ? Image.file(File(widget.filePath ?? ""), fit: BoxFit.cover)
                        : Icon(
                            Icons.person_outline_rounded,
                            size: MediaQuery.of(context).size.width * .125,
                            color: theme.shadowColor,
                          ),
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  title: Text("Name", style: TextStyles.caption(context: context, color: theme.textColor)),
                  subtitle: Text(widget.name, style: TextStyles.body(context: context, color: theme.textColor)),
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  title: Text("Date of birth", style: TextStyles.caption(context: context, color: theme.textColor)),
                  subtitle: Text(
                    DateFormat("dd MMMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(widget.dateOfBirth)),
                    style: TextStyles.body(context: context, color: theme.textColor),
                  ),
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  title: Text("Gender", style: TextStyles.caption(context: context, color: theme.textColor)),
                  subtitle: Text(
                      widget.gender == Gender.male
                          ? "Male"
                          : widget.gender == Gender.female
                              ? "Female"
                              : "Others",
                      style: TextStyles.body(context: context, color: theme.textColor)),
                ),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<UploadCubit, UploadState>(
                        listener: (context, state) async {
                          if (state is UploadSuccess) {
                            imageUrl = state.data;
                            final String token = await FirebaseMessaging.instance.getToken() ?? "";
                            final Passenger passenger = Passenger(widget.reference, widget.name, widget.gender,
                                widget.dateOfBirth, widget.phone, state.data, token, true);
                            BlocProvider.of<RegistrationCubit>(context).save(passenger);
                          }
                        },
                      ),
                      BlocListener<RegistrationCubit, RegistrationState>(
                        listener: (context, state) {
                          if (state is RegistrationSuccess) {
                            Navigator.of(context).pushReplacementNamed(AppRouter.initialization);
                          }
                        },
                      ),
                    ],
                    child: (widget.filePath ?? "").isNotEmpty
                        ? UploadStatesForRegistration(
                            reference: widget.reference,
                            path: widget.filePath ?? "",
                            child: SignUpStatesForRegistration(
                              reference: widget.reference,
                              name: widget.name,
                              gender: widget.gender,
                              phone: widget.phone,
                              dob: widget.dateOfBirth,
                              imageUrl: imageUrl ?? "",
                            ),
                          )
                        : SignUpStatesForRegistration(
                            reference: widget.reference,
                            name: widget.name,
                            gender: widget.gender,
                            phone: widget.phone,
                            dob: widget.dateOfBirth,
                            imageUrl: imageUrl ?? "",
                          ),
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
