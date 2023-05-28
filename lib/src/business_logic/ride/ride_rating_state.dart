part of 'ride_rating_cubit.dart';

@immutable
abstract class RideRatingState {}

class RideRatingInitial extends RideRatingState {}

class RideRatingError extends RideRatingState {
  final String error;

  RideRatingError({required this.error});
}

class RideRatingNetworking extends RideRatingState {}

class RideRatingSuccess extends RideRatingState {}
