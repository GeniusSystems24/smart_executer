import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

final class FakeDemoHttpClient implements DemoHttpClient {
  FakeDemoHttpClient({this.response});

  DemoHttpResponse<dynamic>? response;
  String? lastPath;
  Map<String, dynamic>? lastQueryParameters;

  @override
  Future<DemoHttpResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;
    return response ?? const DemoHttpResponse<dynamic>(data: null);
  }

  @override
  Future<DemoHttpResponse<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;
    return response ?? const DemoHttpResponse<dynamic>(data: null);
  }

  @override
  Future<DemoHttpResponse<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;
    return response ?? const DemoHttpResponse<dynamic>(data: null);
  }

  @override
  Future<DemoHttpResponse<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;
    return response ?? const DemoHttpResponse<dynamic>(data: null);
  }
}
