import 'package:smart_executer_example/app/bootstrap.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/application/contracts/exception_demo_adapter.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/infrastructure/dio_exception_demo_adapter.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/infrastructure/network/dio_demo_http_client.dart';

/// Application composition root for the example.
///
/// Views and controllers depend on abstractions; concrete adapters are created
/// only here.
final class AppDependencies {
  AppDependencies._();

  static DemoHttpClient createHttpClient() => DioDemoHttpClient();

  static ExceptionDemoAdapter createExceptionDemoAdapter() =>
      DioExceptionDemoAdapter(
        applyConfiguration: (builder) =>
            configureSmartExecuter(exceptionBuilder: builder),
      );
}
