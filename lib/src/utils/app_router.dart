import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmoto_passenger/src/business_logic/address/create_address_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/address/delete_address_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/address/saved_address_list_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/address/update_address_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/count_down_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/dashboard/instant_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/dashboard/point_vehicle_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/dashboard/reservation_vehicle_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/driver/driver_rides_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/driver/find_single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/driver/single_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/fare/fare_list_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/login/existence_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/login/generate_otp_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/login/verify_otp_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/passenger/update_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/point/points_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/registration/registration_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/bidding_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/create_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/reservations_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/update_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/cancel_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/complains_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/create_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/direction_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/find_driver_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/ride_rating_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/rides_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/single_ride_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/trips/my_trips_list_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/upload/upload_cubit.dart';
import 'package:tmoto_passenger/src/data/model/address.dart';
import 'package:tmoto_passenger/src/data/model/ride.dart';
import 'package:tmoto_passenger/src/data/model/saved_address.dart';
import 'package:tmoto_passenger/src/presentation/inherited/inherited_ride.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_book_reservation.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_dashboard.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_edit_profile.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_edit_saved_address.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_find_driver.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_initialise_information.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_instant_ride.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_launcher.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_login.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_my_trips.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_new_saved_address.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_otp_verification.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_point_ride.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_profile.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_registration.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_reservation_details.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_reservation_history.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_ride_finish.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_ride_navigation.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_saved_address.dart';
import 'package:tmoto_passenger/src/presentation/screen/screen_track_driver_arrival.dart';

class AppRouter {
  static const String home = "/";
  static const String login = "/login";
  static const String otp = "/otp-verification";
  static const String registration = "/registration";
  static const String dashboard = "/dashboard";
  static const String initialization = "/initialise-information";
  static const String launcher = "/launcher";
  static const String profile = "/profile";
  static const String editProfile = "/profile/edit";
  static const String newSavedAddress = "/saved-addresses/new";
  static const String savedAddresses = "/saved-addresses";
  static const String editSavedAddress = "/saved-addresses/edit";
  static const String myTrips = "/my_trips";

  static const String instantRide = "/dashboard/instant-ride";
  static const String pointRide = "/dashboard/point-ride";
  static const String bookReservation = "/dashboard/book-reservation";
  static const String reservationHistory = "/profile/reservations";
  static const String reservationDetails = "/profile/reservation/details";

  static const String findDriver = "/dashboard/ride/find-driver";
  static const String driverArrivalTracking = "/dashboard/ride/track-driver-arrival";
  static const String rideNavigation = "/dashboard/ride/ride-navigation";
  static const String finishRide = "/dashboard/ride/ride-finish";

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => LauncherScreen());
      case launcher:
        return MaterialPageRoute(builder: (_) => LauncherScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case initialization:
        return MaterialPageRoute(builder: (_) => InitialiseInformationScreen());
      case myTrips:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => MyTripsCubit()),
                  ],
                  child: MyTripsWidget(),
                ));
      case savedAddresses:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => SavedAddressCubit()),
                    BlocProvider(create: (_) => UpdateAddressCubit()),
                    BlocProvider(create: (_) => DeleteAddressCubit()),
                  ],
                  child: SavedAddressListScreen(),
                ));
      case editSavedAddress:
        final SavedAddress savedAddress = settings.arguments as SavedAddress;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SavedAddressCubit()),
              BlocProvider(create: (_) => UpdateAddressCubit()),
            ],
            child: EditSavedAddressScreen(savedAddress),
          ),
        );
      case otp:
        final String phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => CountDownCubit()),
              BlocProvider(create: (_) => GenerateOTPCubit()),
              BlocProvider(create: (_) => VerifyOTPCubit()),
              BlocProvider(create: (_) => ExistenceCubit()),
            ],
            child: OTPVerificationScreen(phoneNumber),
          ),
        );
      case newSavedAddress:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => SavedAddressCubit()),
                    BlocProvider(create: (_) => CreateAddressCubit()),
                  ],
                  child: NewSavedAddressScreen(),
                ));
      case registration:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UploadCubit()),
              BlocProvider(create: (_) => RegistrationCubit()),
            ],
            child: RegistrationScreen(),
          ),
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => RidesCubit()),
              BlocProvider(create: (_) => InstantRideVehicleCubit()),
              BlocProvider(create: (_) => PointVehicleCubit()),
              BlocProvider(create: (_) => ReservationVehicleCubit()),
              BlocProvider(create: (_) => FareListCubit()),
              BlocProvider(create: (_) => UpdateCubit()),
              BlocProvider(create: (_) => SavedAddressCubit()),
              BlocProvider(create: (_) => SingleDriverCubit()),
            ],
            child: DashboardScreen(),
          ),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => RegistrationCubit()),
              BlocProvider(create: (_) => UploadCubit()),
            ],
            child: ProfileScreen(),
          ),
        );
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UploadCubit()),
              BlocProvider(create: (_) => UpdateCubit()),
            ],
            child: EditProfileScreen(),
          ),
        );
      case instantRide:
        final Address? address = settings.arguments as Address?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SavedAddressCubit()),
              BlocProvider(create: (_) => DirectionCubit()),
              BlocProvider(create: (_) => InstantRideVehicleCubit()),
              BlocProvider(create: (_) => CreateRideCubit()),
            ],
            child: InstantRideScreen(address: address),
          ),
        );
      case findDriver:
        final Ride ride = settings.arguments as Ride;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FindDriverCubit()),
              BlocProvider(create: (_) => DriverRidesCubit()),
              BlocProvider(create: (_) => CancelRideCubit()),
              BlocProvider(create: (_) => CreateRideCubit()),
              BlocProvider(create: (_) => SingleRideCubit()),
            ],
            child: InheritedRide(ride: ride, child: FindDriverScreen()),
          ),
        );
      case driverArrivalTracking:
        final String reference = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SingleRideCubit()),
              BlocProvider(create: (_) => SingleDriverCubit()),
            ],
            child: TrackDriverArrivalScreen(reference),
          ),
        );
      case rideNavigation:
        final String reference = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SingleRideCubit()),
              BlocProvider(create: (_) => SingleDriverCubit()),
            ],
            child: RideNavigationScreen(reference),
          ),
        );
      case finishRide:
        final String reference = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SingleRideCubit()),
              BlocProvider(create: (_) => ComplainsCubit()),
              BlocProvider(create: (_) => RideRatingCubit()),
            ],
            child: RideFinishScreen(reference),
          ),
        );
      case pointRide:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PointsCubit()),
              BlocProvider(create: (_) => CreateRideCubit()),
              BlocProvider(create: (_) => DirectionCubit()),
            ],
            child: PointRideScreen(),
          ),
        );
      case bookReservation:
        final bool? isAmbulance = settings.arguments as bool?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ReservationVehicleCubit()),
              BlocProvider(create: (_) => CreateReservationCubit()),
              BlocProvider(create: (_) => DirectionCubit()),
            ],
            child: BookReservationScreen(isAmbulance: isAmbulance),
          ),
        );
      case reservationHistory:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ReservationsCubit()),
              BlocProvider(create: (_) => UpdateReservationCubit()),
            ],
            child: ReservationHistoryScreen(),
          ),
        );
      case reservationDetails:
        final String reference = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UpdateReservationCubit()),
              BlocProvider(create: (_) => FindSingleDriverCubit()),
              BlocProvider(create: (_) => BiddingCubit()),
            ],
            child: ReservationDetailsScreen(reference: reference),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => LauncherScreen());
    }
  }
}
