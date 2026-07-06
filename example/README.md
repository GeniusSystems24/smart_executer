# Smart Executer Example

A feature-first Flutter example demonstrating `smart_executer` with Clean
Architecture, SOLID boundaries, and MVC controllers.

## Run

```bash
flutter pub get
flutter run
```

## Architecture

- `app/`: bootstrap, routing, theme, and dependency composition.
- `features/`: each example or scenario owns its models, controller, and view.
- `shared/application`: technology-independent contracts.
- `shared/infrastructure`: Dio and other concrete adapters.
- `shared/presentation`: reusable Flutter widgets.
- `core/` and `pages/`: backward-compatible exports for the previous paths.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the dependency rules and MVC map.

## Features demonstrated

- Basic `run`, `execute`, and background operations.
- Type-safe `Success` and `Failure` handling.
- Dialog and SnackBar error views.
- Connectivity checks and offline behavior.
- Pagination, forms, product cards, and an integrated task dashboard.
- Sequential, parallel, debounce, throttle, and retry patterns.
- Pull-to-refresh, optimistic updates, and skeleton loading.
- Custom error and exception builders.

## Configuration

The application-wide setup is isolated in `lib/app/bootstrap.dart`:

```dart
SmartExecuterConfig.initialize(
  enableLogging: kDebugMode,
  defaultErrorMessage: (_) => 'Something went wrong. Please try again.',
  defaultViewType: ErrorViewType.snackBar,
);
```

## Controller example

Views depend on a controller, and controllers depend on the `DemoHttpClient`
contract rather than Dio:

```dart
final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
  () => client.get('/posts/1'),
);

result.fold(
  onSuccess: (response) => updateView(response.data),
  onFailure: (exception) => showFailure(exception.message),
);
```

The concrete `DioDemoHttpClient` is created only by `AppDependencies`.
