import 'package:smart_executer_example/features/examples/retry_patterns/auto_retry/presentation/models/retry_log.dart';

// Compatibility export. New code should import the feature-first path.
export 'package:smart_executer_example/features/examples/retry_patterns/auto_retry/presentation/pages/auto_retry_page.dart';

/// Backward-compatible name for the former presentation enum.
@Deprecated('Use RetryLogType.')
typedef LogType = RetryLogType;
