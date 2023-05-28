import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/upload/upload_cubit.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class UploadStatesForEditProfile extends StatelessWidget {
  final String reference;
  final String path;
  final Widget child;

  UploadStatesForEditProfile({required this.reference, required this.path, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return BlocBuilder<UploadCubit, UploadState>(
          builder: (builderContext, state) {
            if (state is UploadError) {
              return ElevatedButton(
                onPressed: () async {
                  BlocProvider.of<UploadCubit>(builderContext).upload(reference, path);
                },
                child: Text("Try again".toUpperCase(),
                    style: TextStyles.title(context: builderContext, color: theme.errorColor)),
              );
            } else if (state is UploadNetworking) {
              return ElevatedButton(
                onPressed: () async {},
                child:
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.deepPurple))),
              );
            } else if (state is UploadSuccess) {
              return child;
            } else {
              return ElevatedButton(
                onPressed: () async {
                  BlocProvider.of<UploadCubit>(builderContext).upload(reference, path);
                },
                child: Text("Update profile".toUpperCase(),
                    style: TextStyles.title(context: builderContext, color: theme.textColor)),
              );
            }
          },
        );
      },
    );
  }
}
