import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmoto_passenger/src/business_logic/location_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/login/existence_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/passenger/profile_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/provider/provider_driver.dart';
import 'package:tmoto_passenger/src/data/provider/provider_fare.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/data/provider/provider_vehicle.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_launcher.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_on_board.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  final storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  final AppRouter router = AppRouter();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool shouldOnBoard = sharedPreferences.getBool("onboard") ?? true;

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    MultiProvider(
      child: MyApp(router, shouldOnBoard),
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ExistenceCubit()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => FareProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => LocationCubit()),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter router;
  final bool shouldOnBoard;

  MyApp(this.router, this.shouldOnBoard);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return MaterialApp(
          title: 'T-Moto',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            canvasColor: theme.backgroundColor,
            shadowColor: theme.shadowColor,
            indicatorColor: theme.accentColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.secondaryColor,
                elevation: 1,
                shadowColor: theme.hintColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(16),
              ),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: theme.accentColor,
            ),
            iconTheme: IconThemeData(color: theme.iconColor, size: 20),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: theme.iconColor),
              actionsIconTheme: IconThemeData(color: theme.iconColor),
              backgroundColor: theme.backgroundColor,
              elevation: 0,
            ),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory, colorScheme: ColorScheme.fromSwatch(primarySwatch: theme.accentColor).copyWith(background: theme.backgroundColor),
          ),
          home: shouldOnBoard ? OnBoardScreen() : LauncherScreen(),
          onGenerateRoute: (settings) => router.generateRoute(settings),
        );
      },
    );
  }
}
