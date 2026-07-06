import 'package:smart_executer_example/features/scenarios/user_list/domain/entities/demo_user.dart';

// Compatibility export. New code should import the feature-first path.
export 'package:smart_executer_example/features/scenarios/user_list/presentation/pages/user_list_scenario.dart';

/// Backward-compatible name for the former example model.
@Deprecated('Use DemoUser from the feature domain layer.')
typedef User = DemoUser;
