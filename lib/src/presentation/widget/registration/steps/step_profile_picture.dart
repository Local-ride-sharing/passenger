import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class ProfilePictureStep extends StatefulWidget {
  final String? path;
  final Function(String) onSave;

  ProfilePictureStep({required this.path, required this.onSave});

  @override
  _ProfilePictureStepState createState() => _ProfilePictureStepState();
}

class _ProfilePictureStepState extends State<ProfilePictureStep> {
  String? path;

  @override
  void initState() {
    if (widget.path != null) {
      path = widget.path;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.width * .5,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(144),
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
            child: InkWell(
              onTap: () async {
                final XFile? file = await ImagePicker().pickImage(
                    source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, maxHeight: 1024, maxWidth: 1024);
                if (file != null) {
                  setState(() {
                    path = file.path;
                    widget.onSave(path ?? "");
                  });
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: path != null
                  ? Image.file(File(path ?? ""), fit: BoxFit.cover)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_enhance_outlined,
                          size: MediaQuery.of(context).size.width * .25,
                          color: theme.shadowColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Take a snap",
                          style: TextStyles.caption(context: context, color: theme.hintColor),
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
