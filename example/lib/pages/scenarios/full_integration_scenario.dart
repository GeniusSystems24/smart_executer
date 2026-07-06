import 'package:smart_executer_example/features/scenarios/full_integration/domain/entities/demo_task.dart';

// Compatibility export. New code should import the feature-first path.
export 'package:smart_executer_example/features/scenarios/full_integration/presentation/pages/full_integration_scenario.dart';

/// Backward-compatible name for the former example model.
@Deprecated('Use DemoTask from the feature domain layer.')
typedef Task = DemoTask;
