import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

/// Owns submission state and delegates rendering decisions to the view.
final class FormSubmitController extends ChangeNotifier {
  FormSubmitController({required DemoHttpClient client}) : _client = client;

  final DemoHttpClient _client;

  bool _isSubmitting = false;
  Map<String, dynamic>? _lastResult;
  bool _hasError = false;
  SmartException? _lastException;

  bool get isSubmitting => _isSubmitting;
  Map<String, dynamic>? get lastResult => _lastResult;
  bool get hasError => _hasError;
  SmartException? get lastException => _lastException;

  Future<bool> submit(
    BuildContext context, {
    required String title,
    required String body,
  }) async {
    _isSubmitting = true;
    _lastResult = null;
    _hasError = false;
    _lastException = null;
    notifyListeners();

    var succeeded = false;
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.post(
        '/posts',
        data: {'title': title, 'body': body, 'userId': 1},
      ),
      context: context,
      options: const ExecuterOptions(
        operationName: 'createPost',
        metadata: {'action': 'form_submit'},
      ),
      onSuccess: (response) async {
        _lastResult = Map<String, dynamic>.from(response.data as Map);
        _hasError = false;
        succeeded = true;
      },
      onError: (exception) async {
        _lastException = exception;
        _lastResult = {'error': exception.message};
        _hasError = true;
      },
    );

    _isSubmitting = false;
    notifyListeners();
    return succeeded;
  }

  void clearResult() {
    _lastResult = null;
    _hasError = false;
    _lastException = null;
    notifyListeners();
  }
}
