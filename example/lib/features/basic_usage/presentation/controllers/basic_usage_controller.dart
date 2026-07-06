import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

/// Coordinates the interactive operations on the basic-usage page.
final class BasicUsageController extends ChangeNotifier {
  BasicUsageController({required DemoHttpClient client}) : _client = client;

  final DemoHttpClient _client;

  String? _result;
  bool _isError = false;
  bool _isLoading = false;

  String? get result => _result;
  bool get isError => _isError;
  bool get isLoading => _isLoading;

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> runWithDialog(BuildContext context) async {
    _setLoading(true);
    final response = await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/posts/1'),
      context: context,
    );
    if (response != null) {
      _setResult('✓ Title: ${(response.data as Map)['title']}');
    }
    _setLoading(false);
  }

  Future<void> runInBackground(BuildContext context) async {
    _setResult('⏳ Loading in background...');
    final response = await SmartExecuter.inBackground<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/posts/2'),
      context: context,
    );
    if (response != null) {
      _setResult('✓ Background: ${(response.data as Map)['title']}');
    }
  }

  Future<void> executeWithResult() async {
    final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
      () => _client.get('/posts/3'),
    );
    switch (result) {
      case Success(:final data):
        _setResult('✓ Success: ${(data.data as Map)['title']}');
      case Failure(:final exception):
        _setResult('✗ Failed: ${exception.message}', isError: true);
    }
  }

  Future<void> handleFailure() async {
    final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
      () => _client.get('/posts/invalid'),
    );
    result.fold(
      onSuccess: (data) => _setResult('Got: ${data.data}'),
      onFailure: (exception) => _setResult(
        '✗ Error handled: ${exception.message}',
        isError: true,
      ),
    );
  }

  Future<void> runWithMetadata(BuildContext context) async {
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(
        operationName: 'fetchPost',
        metadata: {'userId': 'user_123'},
      ),
      onSuccess: (response) async =>
          _setResult('✓ With metadata: ${(response.data as Map)['title']}'),
      onError: (exception) async => _setResult(
        '✗ Error: ${exception.message}\n'
        'Metadata: ${exception.metadata.operationName}',
        isError: true,
      ),
    );
  }

  Future<void> checkConnection() async {
    final hasConnection = await ConnectivityChecker.hasConnection();
    final isWifi = await ConnectivityChecker.isConnectedViaWifi();
    final isMobile = await ConnectivityChecker.isConnectedViaMobile();
    _setResult(
      '📶 Connection: $hasConnection\n'
      '📡 WiFi: $isWifi\n'
      '📱 Mobile: $isMobile',
    );
  }

  Future<void> runWithConnectionCheck(BuildContext context) async {
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(checkConnection: true),
      onConnectionError: () async =>
          _setResult('📴 No connection', isError: true),
      onSuccess: (response) async =>
          _setResult('✓ Connected: ${(response.data as Map)['title']}'),
    );
  }

  Future<void> triggerSnackBarError(BuildContext context) async {
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/posts/invalid-path-snackbar'),
      context: context,
      viewType: ErrorViewType.snackBar,
    );
  }

  Future<void> triggerDialogError(BuildContext context) async {
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.get('/posts/invalid-path-dialog'),
      context: context,
      viewType: ErrorViewType.dialog,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setResult(String value, {bool isError = false}) {
    _result = value;
    _isError = isError;
    notifyListeners();
  }
}
