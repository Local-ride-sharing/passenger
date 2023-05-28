part of 'fare_list_cubit.dart';

@immutable
abstract class FareListState {}

class FareListInitial extends FareListState {}

class FareListError extends FareListState {
  final String error;

  FareListError({required this.error});
}

class FareListNetworking extends FareListState {}

class FareListSuccess extends FareListState {
  final List<Fare> data;

  FareListSuccess({required this.data});
}