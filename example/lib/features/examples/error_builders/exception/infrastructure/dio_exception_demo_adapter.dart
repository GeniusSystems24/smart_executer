import 'package:dio/dio.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/application/contracts/exception_demo_adapter.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/domain/models/exception_demo_case.dart';

/// Dio implementation used only by the exception-mapping demonstration.
final class DioExceptionDemoAdapter implements ExceptionDemoAdapter {
  DioExceptionDemoAdapter({
    required void Function(ExceptionBuilder? builder) applyConfiguration,
  }) : _applyConfiguration = applyConfiguration;

  final void Function(ExceptionBuilder? builder) _applyConfiguration;

  @override
  void configure({required bool useCustomBuilder}) {
    _applyConfiguration(useCustomBuilder ? _mapException : null);
  }

  SmartException? _mapException(
    Object error,
    StackTrace? stackTrace,
    ExceptionMetadata metadata,
  ) {
    if (error is DioException && error.response?.statusCode == 403) {
      return ResponseException(
        message: 'You do not have permission to perform this action',
        statusCode: 403,
        responseData: error.response?.data,
        cause: error,
        stackTrace: stackTrace,
        metadata: metadata,
      );
    }

    if (error is DioException &&
        error.response?.statusCode != null &&
        error.response!.statusCode! >= 400) {
      final data = error.response?.data;
      final serverMessage = data is Map ? data['message'] as String? : null;
      if (serverMessage != null) {
        return ResponseException(
          message: serverMessage,
          statusCode: error.response!.statusCode,
          responseData: data,
          cause: error,
          stackTrace: stackTrace,
          metadata: metadata,
        );
      }
    }

    if (error is FormatException) {
      return UnknownException(
        'Invalid data format received from server',
        error,
        stackTrace,
        metadata,
      );
    }

    return null;
  }

  @override
  Object createError(ExceptionDemoCase demoCase) {
    return switch (demoCase) {
      ExceptionDemoCase.forbidden => _responseError(
          path: '/api/admin',
          statusCode: 403,
          data: const {'error': 'Forbidden'},
        ),
      ExceptionDemoCase.validation => _responseError(
          path: '/api/users',
          statusCode: 422,
          data: const {'message': 'Email already exists'},
        ),
      ExceptionDemoCase.invalidFormat =>
        const FormatException('Unexpected character'),
      ExceptionDemoCase.connection => DioException(
          requestOptions: RequestOptions(path: '/api/data'),
          type: DioExceptionType.connectionError,
          message: 'Connection refused',
        ),
    };
  }

  DioException _responseError({
    required String path,
    required int statusCode,
    required Object data,
  }) {
    final request = RequestOptions(path: path);
    return DioException(
      requestOptions: request,
      response: Response<Object>(
        requestOptions: request,
        statusCode: statusCode,
        data: data,
      ),
      type: DioExceptionType.badResponse,
    );
  }
}
