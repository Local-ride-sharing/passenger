part of 'upload_cubit.dart';

@immutable
abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadNetworking extends UploadState {}

class UploadError extends UploadState {
  final String error;

  UploadError({required this.error});
}

class UploadSuccess extends UploadState {
  final String data;

  UploadSuccess({required this.data});
}
