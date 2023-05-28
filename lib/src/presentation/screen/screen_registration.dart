import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/custom_step.dart';
import 'package:tmoto_passenger/src/presentation/widget/registration/steps/step_dob.dart';
import 'package:tmoto_passenger/src/presentation/widget/registration/steps/step_finish.dart';
import 'package:tmoto_passenger/src/presentation/widget/registration/steps/step_gender.dart';
import 'package:tmoto_passenger/src/presentation/widget/registration/steps/step_name.dart';
import 'package:tmoto_passenger/src/presentation/widget/registration/steps/step_profile_picture.dart';
import 'package:tmoto_passenger/src/presentation/widget/widget_stepper.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/helper.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';
import 'package:uuid/uuid.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int currentIndex = 0;

  String name = "";
  int dateOfBirth = DateTime(2000, 1, 1).millisecondsSinceEpoch;
  Gender gender = Gender.male;
  String? profilePicturePath;

  late String reference;

  @override
  void initState() {
    final Uuid uuid = Uuid();
    reference = uuid.v4();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: StepperWidget(
              steps: [
                CustomStep(
                  icon: Icons.person_outline_rounded,
                  title: "Profile picture",
                  content: ProfilePictureStep(
                    path: profilePicturePath,
                    onSave: (url) {
                      setState(() {
                        profilePicturePath = url;
                      });
                    },
                  ),
                ),
                CustomStep(
                  icon: Icons.person,
                  title: "Full Name",
                  content: NameStep(
                    name: name,
                    onSave: (fullName) {
                      setState(() {
                        name = fullName;
                      });
                    },
                  ),
                ),
                CustomStep(
                  icon: MdiIcons.idCard,
                  title: "Gender",
                  content: GenderStep(
                    gender: gender,
                    onSave: (genderSelection) {
                      setState(() {
                        gender = genderSelection;
                      });
                    },
                  ),
                ),
                CustomStep(
                  icon: MdiIcons.idCard,
                  title: "Date of birth",
                  content: DobStep(
                    dob: dateOfBirth,
                    onSave: (dob) {
                      dateOfBirth = dob;
                    },
                  ),
                ),
                CustomStep(
                  icon: Icons.check,
                  title: "Finish",
                  content: FinishStep(
                    reference: reference,
                    name: name,
                    dateOfBirth: dateOfBirth,
                    gender: gender,
                    phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? "",
                    filePath: profilePicturePath,
                  ),
                ),
              ],
              currentIndex: currentIndex,
              onBack: () {
                setState(() {
                  currentIndex -= 1;
                });
              },
              onNext: () {
                if (currentIndex == 1) {
                  if ((name).isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(getErrorSnackBar(context, "Name not found"));
                  } else {
                    setState(() {
                      currentIndex += 1;
                    });
                  }
                } else {
                  setState(() {
                    currentIndex += 1;
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }
}
