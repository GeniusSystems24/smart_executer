import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

/// Minimal HTTP abstraction required by the examples.
abstract interface class DemoHttpClient {
  Future<DemoHttpResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<DemoHttpResponse<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<DemoHttpResponse<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<DemoHttpResponse<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}
