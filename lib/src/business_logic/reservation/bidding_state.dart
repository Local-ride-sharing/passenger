part of 'bidding_cubit.dart';


@immutable
abstract class BiddingState {}

class BiddingInitial extends BiddingState {}

class BiddingError extends BiddingState {
  final String error;

  BiddingError({required this.error});
}

class BiddingNetworking extends BiddingState {}

class BiddingSuccess extends BiddingState {
  final Reservation data;

  BiddingSuccess({required this.data});
}
