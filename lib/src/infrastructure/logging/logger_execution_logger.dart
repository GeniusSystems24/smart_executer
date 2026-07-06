import 'package:logger/logger.dart';
import 'package:smart_executer/src/application/contracts/execution_logger.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Execution logger backed by the `logger` package.
final class LoggerExecutionLogger implements ExecutionLogger {
  LoggerExecutionLogger({
    required this.enabledProvider,
    Logger? logger,
  }) : _logger = logger ?? Logger();

  final bool Function() enabledProvider;
  final Logger _logger;

  @override
  void logError(
    String category,
    Object error,
    StackTrace stackTrace,
    ExceptionMetadata metadata,
  ) {
    if (!enabledProvider()) return;

    final metadataText = metadata.hasData ? ' | Metadata: $metadata' : '';
    _logger.e(
      '$category: $error$metadataText',
      stackTrace: stackTrace,
    );
  }
}
