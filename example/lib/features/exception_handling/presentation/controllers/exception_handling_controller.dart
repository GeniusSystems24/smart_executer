import 'package:flutter/foundation.dart';
import 'package:smart_executer/smart_executer.dart';

/// Stores the currently selected exception for the showcase view.
final class ExceptionHandlingController extends ChangeNotifier {
  SmartException? _lastException;

  SmartException? get lastException => _lastException;

  void select(SmartException exception) {
    _lastException = exception;
    notifyListeners();
  }

  void clear() {
    _lastException = null;
    notifyListeners();
  }
}
