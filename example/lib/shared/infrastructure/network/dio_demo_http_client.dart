import 'package:dio/dio.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

/// Dio adapter for [DemoHttpClient].
///
/// Dio exceptions are intentionally allowed to bubble up so SmartExecuter can
/// demonstrate its native Dio error mapping behavior.
final class DioDemoHttpClient implements DemoHttpClient {
  DioDemoHttpClient({
    Dio? dio,
    String baseUrl = 'https://jsonplaceholder.typicode.com',
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  final Dio _dio;

  @override
  Future<DemoHttpResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    return _map(response);
  }

  @override
  Future<DemoHttpResponse<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return _map(response);
  }

  @override
  Future<DemoHttpResponse<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return _map(response);
  }

  @override
  Future<DemoHttpResponse<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.delete<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return _map(response);
  }

  DemoHttpResponse<dynamic> _map(Response<dynamic> response) {
    return DemoHttpResponse<dynamic>(
      data: response.data,
      statusCode: response.statusCode,
    );
  }
}
