import 'package:flutter/foundation.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/pull_to_refresh/domain/entities/demo_post.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

final class PullToRefreshController extends ChangeNotifier {
  PullToRefreshController({required DemoHttpClient client}) : _client = client;

  final DemoHttpClient _client;
  final List<DemoPost> _posts = [];
  bool _isLoading = true;
  String? _error;
  DateTime? _lastRefresh;

  List<DemoPost> get posts => List.unmodifiable(_posts);
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastRefresh => _lastRefresh;

  Future<bool> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
      () => _client.get('/posts', queryParameters: {'_limit': 15}),
    );

    var succeeded = false;
    result.fold(
      onSuccess: (response) {
        _posts
          ..clear()
          ..addAll(
            (response.data as List<dynamic>).map(
              (json) => DemoPost.fromJson(json as Map<String, dynamic>),
            ),
          );
        _lastRefresh = DateTime.now();
        succeeded = true;
      },
      onFailure: (exception) => _error = exception.message,
    );

    _isLoading = false;
    notifyListeners();
    return succeeded;
  }
}
