import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/application/contracts/exception_demo_adapter.dart';
import 'package:smart_executer_example/features/examples/error_builders/exception/domain/models/exception_demo_case.dart';

/// Coordinates the exception-builder demonstration.
final class ExceptionBuilderController extends ChangeNotifier {
  ExceptionBuilderController({required ExceptionDemoAdapter adapter})
      : _adapter = adapter;

  final ExceptionDemoAdapter _adapter;

  bool _useCustomBuilder = false;
  String _lastExceptionType = '';
  String _lastMessage = '';

  bool get useCustomBuilder => _useCustomBuilder;
  String get lastExceptionType => _lastExceptionType;
  String get lastMessage => _lastMessage;

  void setUseCustomBuilder(bool value) {
    if (_useCustomBuilder == value) return;
    _useCustomBuilder = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _adapter.configure(useCustomBuilder: false);
    super.dispose();
  }

  Future<void> trigger(
    BuildContext context,
    ExceptionDemoCase demoCase,
  ) async {
    _adapter.configure(useCustomBuilder: _useCustomBuilder);

    final result = await SmartExecuter.execute<void>(
      () => Future<void>.delayed(
        const Duration(milliseconds: 300),
        () => throw _adapter.createError(demoCase),
      ),
      context: context,
      viewType: ErrorViewType.snackBar,
      operationName: 'exceptionBuilderDemo',
    );

    result.onFailure((exception) {
      _lastExceptionType = exception.runtimeType.toString();
      _lastMessage = exception.message;
      notifyListeners();
    });
  }
}
