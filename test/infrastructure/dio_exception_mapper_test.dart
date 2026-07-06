import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer/smart_executer.dart';

void main() {
  test('maps a 401 Dio response to SessionExpiredException', () {
    final request = RequestOptions(path: '/profile', method: 'GET');
    final dioException = DioException(
      requestOptions: request,
      response: Response<void>(
        requestOptions: request,
        statusCode: 401,
      ),
      type: DioExceptionType.badResponse,
    );

    final exception = ExceptionMapper.fromDioException(
      dioException,
      const ExceptionMetadata(operationName: 'profile'),
    );

    expect(exception, isA<SessionExpiredException>());
    expect(exception.metadata.endpoint, '/profile');
    expect(exception.metadata.requestMethod, 'GET');
    expect(exception.metadata.operationName, 'profile');
  });

  test('keeps Flutter presentation metadata source-compatible', () {
    final color = SmartExceptionType.connection.color;
    final icon = SmartExceptionType.connection.icon;

    expect(color, isNotNull);
    expect(icon, isNotNull);
  });
}
