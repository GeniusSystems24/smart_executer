/// Transport-independent HTTP response used by the example application.
///
/// Keeping this model outside the Dio implementation prevents presentation
/// controllers from depending on a specific networking package.
final class DemoHttpResponse<T> {
  const DemoHttpResponse({
    required this.data,
    this.statusCode,
  });

  final T data;
  final int? statusCode;
}
