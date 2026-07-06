import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/domain/models/exception_demo_case.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/infrastructure/dio_exception_demo_adapter.dart';

void main() {
  test('custom exception mapping is applied and can be disabled', () {
    ExceptionBuilder? configuredBuilder;
    final adapter = DioExceptionDemoAdapter(
      applyConfiguration: (builder) => configuredBuilder = builder,
    );

    adapter.configure(useCustomBuilder: true);
    final builder = configuredBuilder;
    expect(builder, isNotNull);

    final exception = builder!(
      adapter.createError(ExceptionDemoCase.forbidden),
      null,
      const ExceptionMetadata(operationName: 'test'),
    );

    expect(exception, isA<ResponseException>());
    expect(exception?.message, contains('permission'));
    expect((exception as ResponseException).statusCode, 403);

    adapter.configure(useCustomBuilder: false);
    expect(configuredBuilder, isNull);
  });
}
