import 'package:smart_executer/src/application/services/operation_executor.dart';
import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/infrastructure/connectivity/connectivity_plus_service.dart';
import 'package:smart_executer/src/infrastructure/errors/default_exception_factory.dart';
import 'package:smart_executer/src/infrastructure/logging/logger_execution_logger.dart';
import 'package:smart_executer/src/presentation/controllers/smart_executer_controller.dart';

/// Package composition root.
///
/// Concrete infrastructure is created only here and injected into the
/// controller through application-layer interfaces.
abstract final class SmartExecuterRuntime {
  static final ConnectivityPlusService connectivityService =
      ConnectivityPlusService();

  static final DefaultExceptionFactory _exceptionFactory =
      DefaultExceptionFactory(
    customBuilderProvider: () => SmartExecuterConfig.instance.exceptionBuilder,
  );

  static final LoggerExecutionLogger _logger = LoggerExecutionLogger(
    enabledProvider: () => SmartExecuterConfig.instance.enableLogging,
  );

  static final OperationExecutor _operationExecutor = DefaultOperationExecutor(
    connectivityService: connectivityService,
    exceptionFactory: _exceptionFactory,
    logger: _logger,
  );

  static final SmartExecuterController controller = SmartExecuterController(
    operationExecutor: _operationExecutor,
    configProvider: () => SmartExecuterConfig.instance,
  );
}
