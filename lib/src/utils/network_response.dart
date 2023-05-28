class NetworkResponse<T> {
  final T? result;
  final bool success;
  final String? error;

  NetworkResponse({required this.result, required this.success, this.error});
}
