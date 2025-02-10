
class ResponseHandler {
  final bool success;
  final bool loading;
  final dynamic data;
  final dynamic error;

  ResponseHandler._({
    required this.success,
    this.loading = false,
    this.data,
    this.error,
  });

  factory ResponseHandler.success(dynamic data) =>
      ResponseHandler._(success: true, data: data);

  factory ResponseHandler.error(dynamic error) =>
      ResponseHandler._(success: false, error: error);

  factory ResponseHandler.loading() =>
      ResponseHandler._(success: false, loading: true);
}
