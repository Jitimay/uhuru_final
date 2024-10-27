class IsarResponse<T> {
  final int status;
  final String message;
  final T? data;
  const IsarResponse({required this.status, required this.message, this.data});
}
