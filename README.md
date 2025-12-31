# Smart Executer

[![pub package](https://img.shields.io/pub/v/smart_executer.svg)](https://pub.dev/packages/smart_executer)
[![likes](https://img.shields.io/pub/likes/smart_executer)](https://pub.dev/packages/smart_executer/score)
[![popularity](https://img.shields.io/pub/popularity/smart_executer)](https://pub.dev/packages/smart_executer/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful Flutter package for executing async operations with built-in error handling, loading dialogs, retry logic, and Result pattern support.

## Features

- **Loading Dialogs** - Customizable loading dialogs during operations
- **Error Handling** - Comprehensive error handling with specific callbacks for each error type
- **Result Pattern** - Type-safe success/failure handling using sealed classes
- **Retry Logic** - Automatic retry with configurable attempts and delays
- **Connection Checking** - Optional network connectivity verification before requests
- **Session Management** - Built-in session expiration (401) handling
- **Stream Support** - First-class support for stream-based operations with progress tracking
- **Customizable UI** - Fully customizable dialogs, snack bars, and error messages
- **Global Configuration** - Configure once, use everywhere

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_executer: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize (Optional)

Configure SmartExecuter globally in your `main.dart`:

```dart
void main() {
  SmartExecuterConfig.initialize(
    enableLogging: true,
    defaultErrorMessage: 'Something went wrong. Please try again.',
    noConnectionMessage: 'No internet connection',
    maxRetries: 3,
    retryDelay: const Duration(seconds: 1),
  );
  runApp(const MyApp());
}
```

### 2. Basic Usage

```dart
// Execute with loading dialog
final user = await SmartExecuter.run(
  () => apiService.getUser(id),
  context: context,
);

if (user != null) {
  print('User: ${user.name}');
}
```

### 3. Background Execution

```dart
// Execute without loading dialog
final data = await SmartExecuter.inBackground(
  () => apiService.refreshCache(),
  context: context,
);
```

## Usage Examples

### Using Result Pattern

The Result pattern provides a type-safe way to handle success and failure cases:

```dart
final result = await SmartExecuter.execute(
  () => apiService.getUser(id),
);

// Using switch expression
switch (result) {
  case Success(:final data):
    print('User: ${data.name}');
  case Failure(:final exception):
    print('Error: ${exception.message}');
}

// Using fold
final userName = result.fold(
  onSuccess: (user) => user.name,
  onFailure: (exception) => 'Unknown',
);

// Using getOrElse
final user = result.getOrElse(User.empty());

// Chaining with map
final userEmail = result
    .map((user) => user.email)
    .getOrElse('no-email@example.com');
```

### With Callbacks

```dart
await SmartExecuter.run(
  () => apiService.createUser(userData),
  context: context,
  onSuccess: (user) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User ${user.name} created!')),
    );
    Navigator.of(context).pop(user);
  },
  onError: (exception) async {
    print('Failed to create user: ${exception.message}');
  },
  onConnectionError: () async {
    print('No internet connection');
  },
  onSessionExpired: () async {
    Navigator.of(context).pushReplacementNamed('/login');
  },
);
```

### With Retry Logic

```dart
final data = await SmartExecuter.run(
  () => apiService.fetchData(),
  context: context,
  options: ExecuterOptions(
    maxRetries: 3,
    retryDelay: const Duration(seconds: 2),
    checkConnection: true,
  ),
);
```

### Stream Operations with Progress

```dart
await SmartExecuter.runStream(
  () => uploadService.uploadWithProgress(file),
  context: context,
  listener: (progress) {
    print('Upload progress: ${progress.percentage}%');
  },
  waitingBuilder: (context, progress) {
    return SmartProgressDialog(
      progress: progress.percentage / 100,
      message: 'Uploading file...',
    );
  },
  onSuccess: (result) async {
    print('Upload complete: ${result.url}');
  },
);
```

### Custom Loading Dialog

```dart
await SmartExecuter.run(
  () => apiService.fetchData(),
  context: context,
  options: ExecuterOptions(
    loadingWidget: const SmartLoadingDialog(
      message: 'Loading data...',
      indicatorColor: Colors.blue,
    ),
  ),
);
```

## Configuration

### Global Configuration

Configure SmartExecuter once at app startup:

```dart
SmartExecuterConfig.initialize(
  // Custom loading dialog
  loadingDialogBuilder: (context) => const MyCustomLoadingDialog(),

  // Custom error snack bar
  errorSnackBarBuilder: (context, exception) => MyErrorSnackBar(
    message: exception.message,
  ),

  // Global error handler
  globalErrorHandler: (exception) async {
    analytics.logError(exception.message);
  },

  // Session expiration handler
  onSessionExpired: () async {
    await authService.logout();
    navigatorKey.currentState?.pushReplacementNamed('/login');
  },

  // Messages
  defaultErrorMessage: 'An error occurred',
  noConnectionMessage: 'No internet connection',
  sessionExpiredMessage: 'Your session has expired',
  sessionExpiredTitle: 'Session Expired',

  // Retry configuration
  maxRetries: 3,
  retryDelay: const Duration(seconds: 1),

  // Connection checking
  checkConnectionByDefault: false,

  // Logging
  enableLogging: kDebugMode,
);
```

### Per-Operation Options

Override global configuration for specific operations:

```dart
final options = ExecuterOptions(
  showLoadingDialog: true,
  checkConnection: true,
  maxRetries: 5,
  retryDelay: const Duration(seconds: 2),
  timeout: const Duration(seconds: 30),
  barrierDismissible: false,
  barrierColor: Colors.black54,
  loadingWidget: const CircularProgressIndicator(),
);

await SmartExecuter.run(
  () => apiService.longRunningOperation(),
  context: context,
  options: options,
);
```

## Exception Types

SmartExecuter provides specific exception types for different error scenarios:

| Exception | Description |
|-----------|-------------|
| `ConnectionException` | No internet connection |
| `ConnectionTimeoutException` | Connection timeout |
| `SendTimeoutException` | Request send timeout |
| `ReceiveTimeoutException` | Response receive timeout |
| `CancelledException` | Request was cancelled |
| `ResponseException` | Server error response |
| `SessionExpiredException` | 401 Unauthorized |
| `UnknownException` | Unknown error |

```dart
final result = await SmartExecuter.execute(() => apiService.getData());

result.onFailure((exception) {
  switch (exception) {
    case ConnectionException():
      showOfflineMessage();
    case SessionExpiredException():
      redirectToLogin();
    case ResponseException(:final statusCode):
      if (statusCode == 404) showNotFoundMessage();
    default:
      showGenericError();
  }
});
```

## Widgets

### SmartLoadingDialog

A customizable loading dialog:

```dart
const SmartLoadingDialog(
  message: 'Please wait...',
  indicatorColor: Colors.blue,
  indicatorSize: 48.0,
  backgroundColor: Colors.white,
  elevation: 8.0,
)
```

### SmartProgressDialog

A loading dialog with progress indicator:

```dart
SmartProgressDialog(
  progress: 0.75,
  message: 'Uploading...',
  showPercentage: true,
  progressColor: Colors.green,
)
```

### SmartErrorSnackBar

An error snack bar with automatic styling:

```dart
SmartErrorSnackBar(
  exception: exception,
  customMessage: 'Custom error message',
  duration: const Duration(seconds: 4),
)
```

### SmartSuccessSnackBar

A success snack bar:

```dart
SmartSuccessSnackBar(
  message: 'Operation completed successfully!',
  duration: const Duration(seconds: 3),
)
```

### Helper Methods

```dart
// Show error
SmartSnackBars.showError(context, exception);

// Show success
SmartSnackBars.showSuccess(context, 'Success!');

// Show custom
SmartSnackBars.show(
  context,
  'Custom message',
  backgroundColor: Colors.orange,
  icon: Icons.warning,
);
```

## Connectivity Checker

Check network connectivity:

```dart
// Check connection
final hasConnection = await ConnectivityChecker.hasConnection();

// Get connection type
final status = await ConnectivityChecker.getStatus();

// Check specific connection type
final isWifi = await ConnectivityChecker.isConnectedViaWifi();
final isMobile = await ConnectivityChecker.isConnectedViaMobile();

// Listen to changes
ConnectivityChecker.onConnectivityChanged.listen((results) {
  if (results.contains(ConnectivityResult.none)) {
    showOfflineIndicator();
  }
});
```

## API Reference

### SmartExecuter Methods

| Method | Description |
|--------|-------------|
| `execute<T>()` | Execute and return Result (no UI) |
| `run<T>()` | Execute with loading dialog |
| `inBackground<T>()` | Execute without dialog |
| `runStream<T>()` | Execute stream with dialog |
| `inBackgroundStream<T>()` | Execute stream without dialog |

### ExecuterOptions

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `showLoadingDialog` | `bool` | `true` | Show loading dialog |
| `checkConnection` | `bool?` | `null` | Check connectivity |
| `maxRetries` | `int?` | `null` | Max retry attempts |
| `retryDelay` | `Duration?` | `null` | Delay between retries |
| `timeout` | `Duration?` | `null` | Operation timeout |
| `loadingWidget` | `Widget?` | `null` | Custom loading widget |
| `barrierDismissible` | `bool` | `false` | Can dismiss dialog |
| `barrierColor` | `Color?` | `null` | Dialog barrier color |

## Migration from 0.x

If you're migrating from an earlier version:

1. Replace `ErrorInfoBar` with `SmartErrorSnackBar`
2. Replace `AppWaitingDialog` with `SmartLoadingDialog`
3. Add `SmartExecuterConfig.initialize()` in main.dart
4. Update callback signatures (now use `SmartException`)

## Contributing

Contributions are welcome! Please read our contributing guidelines first.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a star on [GitHub](https://github.com/GeniusSystems24/smart_executer)!

For bugs or feature requests, please [open an issue](https://github.com/GeniusSystems24/smart_executer/issues).
