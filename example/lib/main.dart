import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/bootstrap.dart';
import 'package:smart_executer_example/app/smart_executer_example_app.dart';

/// Backward-compatible application widget name used by the original example.
@Deprecated('Use SmartExecuterExampleApp.')
typedef SmartExecuterDemo = SmartExecuterExampleApp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureSmartExecuter();
  runApp(const SmartExecuterExampleApp());
}
