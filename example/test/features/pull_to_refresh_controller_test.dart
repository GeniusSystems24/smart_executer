import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/pull_to_refresh/presentation/controllers/pull_to_refresh_controller.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

import '../support/fake_demo_http_client.dart';

void main() {
  test('loads and maps posts through the HTTP abstraction', () async {
    final client = FakeDemoHttpClient(
      response: const DemoHttpResponse<dynamic>(
        data: [
          {'id': 7, 'title': 'Clean example', 'body': 'Mapped by controller'},
        ],
        statusCode: 200,
      ),
    );
    final controller = PullToRefreshController(client: client);

    final succeeded = await controller.load();

    expect(succeeded, isTrue);
    expect(client.lastPath, '/posts');
    expect(client.lastQueryParameters, {'_limit': 15});
    expect(controller.posts, hasLength(1));
    expect(controller.posts.single.id, 7);
    expect(controller.posts.single.title, 'Clean example');
    expect(controller.error, isNull);
    expect(controller.isLoading, isFalse);
  });
}
