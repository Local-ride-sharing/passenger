import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/location_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class LauncherScreen extends StatefulWidget {
  @override
  _LauncherScreenState createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1), () {
      BlocProvider.of<LocationCubit>(context).track();
      Navigator.of(context)
          .pushReplacementNamed(FirebaseAuth.instance.currentUser == null ? AppRouter.login : AppRouter.initialization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Center(child: Image.asset("images/logo.png", width: 144, height: 144, fit: BoxFit.contain)),
        );
      },
    );
  }
}
