# Smart Executer

[![pub package](https://img.shields.io/pub/v/smart_executer.svg)](https://pub.dev/packages/smart_executer)
[![likes](https://img.shields.io/pub/likes/smart_executer)](https://pub.dev/packages/smart_executer/score)
[![popularity](https://img.shields.io/pub/popularity/smart_executer)](https://pub.dev/packages/smart_executer/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![points](https://img.shields.io/pub/points/smart_executer)](https://pub.dev/packages/smart_executer/score)
[![Platform](https://img.shields.io/badge/Platform-All-blueviolet)](https://flutter.dev)
[![Live Demo](https://img.shields.io/badge/🚀_Live_Demo-View_Online-success)](https://geniussystems24.github.io/smart_executer)

A powerful Flutter package for executing async operations with built-in error handling, loading dialogs, error builders, and Result pattern support.

## Features

- **Loading Dialogs** - Customizable loading dialogs during operations
- **Error Handling** - Comprehensive error handling with specific callbacks for each error type
- **Error Builders** - Per-exception-type SnackBar and Dialog builders with full metadata access
- **Error View Types** - Display errors as SnackBars or Dialogs with `ErrorViewType`
- **Result Pattern** - Type-safe success/failure handling using sealed classes
- **Exception Metadata** - Attach debugging info to exceptions for better error tracking
- **Connection Checking** - Optional network connectivity verification before requests
- **Session Management** - Built-in session expiration (401) handling
- **Stream Support** - First-class support for stream-based operations with progress tracking
- **Status Cards** - Ready-to-use cards for error, success, warning, info, and empty states
- **Customizable UI** - Fully customizable dialogs, snack bars, and error messages
- **Global Configuration** - Configure once, use everywhere

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_executer: ^2.3.0
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
    defaultErrorMessage: (_) => 'Something went wrong. Please try again.',
    noConnectionMessage: (_) => 'No internet connection',
  );
  runApp(const MyApp());
}
```

### 2. Basic Usage

```dart
// Execute with loading dialog
final user = await SmartExecuter.run(
  request: () => apiService.getUser(id),
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
  request: () => apiService.refreshCache(),
  context: context,
);
```

### 4. Error View Types

Choose how errors are displayed — as a SnackBar or Dialog:

```dart
// Show errors as a dialog
final user = await SmartExecuter.run(
  request: () => apiService.getUser(id),
  context: context,
  viewType: ErrorViewType.dialog,
);

// Show errors as a snackbar (default)
final data = await SmartExecuter.inBackground(
  request: () => apiService.refreshCache(),
  context: context,
  viewType: ErrorViewType.snackBar,
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

### With Exception Metadata (Debugging)

Attach metadata to exceptions for better debugging and error tracking:

```dart
await SmartExecuter.run(
  () => apiService.createOrder(orderData),
  context: context,
  options: ExecuterOptions(
    operationName: 'createOrder',
    metadata: {
      'userId': currentUser.id,
      'orderId': order.id,
      'screen': 'checkout',
      'cartItems': cart.itemCount,
    },
  ),
  onError: (exception) async {
    // Access metadata in the exception
    print('Operation: ${exception.metadata.operationName}');
    print('Endpoint: ${exception.metadata.endpoint}');
    print('Method: ${exception.metadata.requestMethod}');
    print('Timestamp: ${exception.metadata.timestamp}');
    print('Extra: ${exception.metadata.extra}');

    // Send to analytics/crash reporting
    analytics.logError(
      exception.metadata.operationName ?? 'unknown',
      exception.metadata.toMap(),
    );
  },
);
```

Using with `execute()`:

```dart
final result = await SmartExecuter.execute(
  () => apiService.fetchUser(id),
  operationName: 'fetchUser',
  metadata: {'userId': id, 'source': 'profile_page'},
);

result.onFailure((exception) {
  // Full debugging context available
  crashlytics.recordError(
    exception,
    reason: exception.metadata.operationName,
    information: [
      'endpoint: ${exception.metadata.endpoint}',
      'method: ${exception.metadata.requestMethod}',
      ...exception.metadata.toMap().entries.map((e) => '${e.key}: ${e.value}'),
    ],
  );
});
```

### Error Builders

Configure per-exception-type error builders globally:

```dart
SmartExecuterConfig.initialize(
  // Custom SnackBar builders
  snackBarErrorBuilder: SnackBarErrorBuilder(
    baseBuilder: (context, exception) => SnackBar(
      content: Text(exception.message),
    ),
    connectionBuilder: (context, exception) => SnackBar(
      content: Text('No internet: ${exception.metadata.operationName}'),
      backgroundColor: Colors.orange,
    ),
  ),

  // Custom Dialog builders
  dialogErrorBuilder: DialogErrorBuilder(
    baseBuilder: (context, exception) => AlertDialog(
      title: const Text('Error'),
      content: Text(exception.message),
    ),
    responseBuilder: (context, exception) {
      final resp = exception as ResponseException;
      return AlertDialog(
        title: Text('Server Error ${resp.statusCode}'),
        content: Text(resp.message),
      );
    },
  ),
);
```

### Per-Operation Error Builders

Override global error builders for a single operation:

```dart
// Use a custom snackbar builder just for this operation
final result = await SmartExecuter.execute(
  () => apiService.deleteAccount(),
  context: context,
  viewType: ErrorViewType.snackBar,
  snackBarErrorBuilder: SnackBarErrorBuilder(
    baseBuilder: (context, exception) => SnackBar(
      content: Text('Delete failed: ${exception.message}'),
      backgroundColor: Colors.red,
      action: SnackBarAction(label: 'RETRY', onPressed: () {}),
    ),
  ),
);

// Use a custom dialog builder just for this operation
await SmartExecuter.run(
  request: () => apiService.processPayment(amount),
  context: context,
  viewType: ErrorViewType.dialog,
  dialogErrorBuilder: DialogErrorBuilder(
    baseBuilder: (context, exception) => AlertDialog(
      title: const Text('Payment Failed'),
      content: Text(exception.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Try Again'),
        ),
      ],
    ),
  ),
);
```

Resolution order: **per-operation builder → global config builder → package default**.

### Stream Operations with Progress

```dart
await SmartExecuter.runStream(
  () => uploadService.uploadWithProgress(file),
  context: context,
  options: ExecuterOptions(
    operationName: 'uploadFile',
    metadata: {'fileName': file.name, 'fileSize': file.size},
  ),
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

  // Custom error builders (optional — defaults are used if not provided)
  snackBarErrorBuilder: SnackBarErrorBuilder(
    baseBuilder: (context, exception) => SnackBar(
      content: Text(exception.message),
    ),
  ),
  dialogErrorBuilder: DialogErrorBuilder(
    baseBuilder: (context, exception) => AlertDialog(
      title: const Text('Error'),
      content: Text(exception.message),
    ),
  ),

  // Global error handler
  globalErrorHandler: (exception) async {
    logger.error(
      'Error in ${exception.metadata.operationName}',
      error: exception,
      extra: exception.metadata.toMap(),
    );
  },

  // Session expiration handler
  onSessionExpired: () async {
    await authService.logout();
    navigatorKey.currentState?.pushReplacementNamed('/login');
  },

  // Messages — use String Function(BuildContext) for dynamic/localized strings
  defaultErrorMessage: (_) => 'An error occurred',
  noConnectionMessage: (_) => 'No internet connection',
  sessionExpiredMessage: (_) => 'Your session has expired',
  sessionExpiredTitle: (_) => 'Session Expired',
  // Or with localization (context provided at error time):
  // noConnectionMessage: (context) => AppLocalizations.of(context)!.noConnection,

  // Default error view type for all operations
  defaultViewType: ErrorViewType.snackBar,

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
  timeout: const Duration(seconds: 30),
  barrierDismissible: false,
  barrierColor: Colors.black54,
  loadingWidget: const CircularProgressIndicator(),
  operationName: 'longRunningOperation',
  metadata: {'priority': 'high'},
);

await SmartExecuter.run(
  request: () => apiService.longRunningOperation(),
  context: context,
  viewType: ErrorViewType.dialog,
  options: options,
);
```

## Exception Metadata

All exceptions include metadata for debugging:

### ExceptionMetadata Fields

| Field | Type | Description |
|-------|------|-------------|
| `operationName` | `String?` | Name of the operation (e.g., 'fetchUser') |
| `endpoint` | `String?` | API endpoint (auto-extracted from Dio) |
| `requestMethod` | `String?` | HTTP method (auto-extracted from Dio) |
| `userId` | `String?` | User identifier |
| `sessionId` | `String?` | Session identifier |
| `timestamp` | `DateTime?` | When the error occurred |
| `extra` | `Map<String, dynamic>?` | Custom data |

### Using Metadata

```dart
// Access metadata from exception
exception.metadata.operationName  // 'createOrder'
exception.metadata.endpoint       // '/api/orders'
exception.metadata.requestMethod  // 'POST'
exception.metadata.timestamp      // 2024-01-01 12:00:00
exception.metadata.extra          // {'userId': '123', 'orderId': '456'}

// Check if metadata has data
if (exception.metadata.hasData) {
  print(exception.metadata);
}

// Convert to Map for logging/serialization
final map = exception.metadata.toMap();
// {operationName: 'createOrder', endpoint: '/api/orders', ...}

// Attach metadata to existing exception
final enrichedException = exception.withMetadata(
  ExceptionMetadata(
    operationName: 'retryOperation',
    extra: {'attempt': 2},
  ),
);
```

## Exception Types

SmartExecuter provides specific exception types for different error scenarios.
Each exception has an `exceptionType` getter for convenient type identification:

| Exception | `exceptionType` | Description |
|-----------|-----------------|-------------|
| `ConnectionException` | `connection` | No internet connection |
| `ConnectionTimeoutException` | `connectionTimeout` | Connection timeout |
| `SendTimeoutException` | `sendTimeout` | Request send timeout |
| `ReceiveTimeoutException` | `receiveTimeout` | Response receive timeout |
| `CancelledException` | `cancelled` | Request was cancelled |
| `ResponseException` | `response` | Server error response |
| `SessionExpiredException` | `sessionExpired` | 401 Unauthorized |
| `UnknownException` | `unknown` | Unknown error |

```dart
final result = await SmartExecuter.execute(() => apiService.getData());

result.onFailure((exception) {
  // Use exceptionType for simple type checks
  if (exception.exceptionType == SmartExceptionType.connection) {
    showOfflineMessage();
    return;
  }

  // Or use switch on exceptionType
  switch (exception.exceptionType) {
    case SmartExceptionType.connection:
      showOfflineMessage();
    case SmartExceptionType.sessionExpired:
      redirectToLogin();
    case SmartExceptionType.response:
      final resp = exception as ResponseException;
      if (resp.statusCode == 404) showNotFoundMessage();
    default:
      showGenericError();
  }

  // Pattern matching still works for accessing subclass data
  switch (exception) {
    case ResponseException(:final statusCode):
      print('Status: $statusCode');
    default:
      print('Error: ${exception.message}');
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

An error snack bar with per-exception-type icons and colors:

```dart
SmartErrorSnackBar(
  exception: exception,
  customMessage: 'Custom error message',
  duration: const Duration(seconds: 4),
)
```

### SmartErrorDialog

A modern error dialog with per-exception-type styling:

```dart
SmartErrorDialog(
  exception: exception,
  customMessage: 'Custom error message',
  customTitle: 'Custom Title',
  onDismiss: () => print('Dialog dismissed'),
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

## Status Cards

Ready-to-use cards for displaying different states in your UI.

### Basic Cards

```dart
// Error card
SmartErrorCard(
  title: 'Something went wrong',
  message: 'Please try again later',
  action: 'Retry',
  onActionPressed: () => fetchData(),
)

// Success card
SmartSuccessCard(
  title: 'Success!',
  message: 'Your order has been placed',
  action: 'Continue',
  onActionPressed: () => navigateHome(),
)

// Warning card
SmartWarningCard(
  title: 'Warning',
  message: 'Your session will expire soon',
  action: 'Extend Session',
  onActionPressed: () => extendSession(),
)

// Info card
SmartInfoCard(
  title: 'Did you know?',
  message: 'Swipe to dismiss notifications',
  action: 'Got it',
  onActionPressed: () => dismiss(),
)

// Empty state card
SmartEmptyCard(
  title: 'No items yet',
  message: 'Add your first item to get started',
  action: 'Add Item',
  onActionPressed: () => addItem(),
)

// Loading card
SmartLoadingCard(
  title: 'Loading...',
  message: 'Please wait while we fetch your data',
)
```

### Pre-configured Cards

Specialized cards with pre-configured titles and messages:

```dart
// Offline card
SmartOfflineCard(
  onActionPressed: () => retry(),
)

// Session expired card
SmartSessionExpiredCard(
  onActionPressed: () => navigateToLogin(),
)

// Timeout card
SmartTimeoutCard(
  onActionPressed: () => retry(),
)

// Server error card
SmartServerErrorCard(
  onActionPressed: () => retry(),
  onSecondaryActionPressed: () => contactSupport(),
)

// Maintenance card
SmartMaintenanceCard()

// Permission denied card
SmartPermissionDeniedCard(
  permission: 'Camera',
  onActionPressed: () => requestPermission(),
  onSecondaryActionPressed: () => openSettings(),
)

// Not found card
SmartNotFoundCard(
  itemName: 'Product',
  onActionPressed: () => goBack(),
)
```

### From Exception

Create error cards directly from exceptions:

```dart
SmartErrorCard.fromException(
  exception,
  action: 'Retry',
  onActionPressed: () => retry(),
)
```

### Available Status Cards

| Card | Description |
|------|-------------|
| `SmartErrorCard` | General error state |
| `SmartSuccessCard` | Success state |
| `SmartWarningCard` | Warning state |
| `SmartInfoCard` | Information state |
| `SmartEmptyCard` | Empty/no data state |
| `SmartLoadingCard` | Loading state |
| `SmartOfflineCard` | No internet connection |
| `SmartSessionExpiredCard` | Session expired |
| `SmartTimeoutCard` | Request timeout |
| `SmartServerErrorCard` | Server error |
| `SmartMaintenanceCard` | Under maintenance |
| `SmartPermissionDeniedCard` | Permission required |
| `SmartNotFoundCard` | Resource not found |

### Custom Widgets

Status cards support full widget customization:

```dart
// Custom title widget
SmartSuccessCard(
  titleWidget: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.verified, color: Colors.green),
      SizedBox(width: 8),
      Text('Verified!', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  ),
  message: 'Your account has been verified',
)

// Custom body widget
SmartInfoCard(
  title: 'Update Available',
  bodyWidget: Column(
    children: [
      Text('Version 2.0.0 is now available'),
      SizedBox(height: 8),
      Text('• New features\n• Bug fixes'),
    ],
  ),
  action: 'Update Now',
  onActionPressed: () => update(),
)

// Custom actions widget
SmartErrorCard(
  title: 'Connection Failed',
  message: 'Unable to connect to server',
  actionsWidget: Column(
    children: [
      FilledButton.icon(
        onPressed: () => retry(),
        icon: Icon(Icons.refresh),
        label: Text('Retry'),
      ),
      TextButton(
        onPressed: () => workOffline(),
        child: Text('Work Offline'),
      ),
    ],
  ),
)

// Custom icon widget
SmartInfoCard(
  title: 'Premium Feature',
  iconWidget: Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(Icons.star, color: Colors.white),
  ),
  message: 'Upgrade to unlock',
)
```

### Close Button

Cards can display a close button:

```dart
SmartInfoCard(
  title: 'Notification',
  message: 'You have a new message',
  showCloseButton: true,
  onClose: () => dismiss(),
  closeButtonColor: Colors.grey,
)

// From exception with close button
SmartErrorCard.fromException(
  exception,
  showCloseButton: true,
  onClose: () => dismiss(),
  action: 'Retry',
  onActionPressed: () => retry(),
)
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
| `timeout` | `Duration?` | `null` | Operation timeout |
| `loadingWidget` | `Widget?` | `null` | Custom loading widget |
| `barrierDismissible` | `bool` | `false` | Can dismiss dialog |
| `barrierColor` | `Color?` | `null` | Dialog barrier color |
| `operationName` | `String?` | `null` | Operation name for debugging |
| `metadata` | `Map<String, dynamic>?` | `null` | Custom metadata for exceptions |

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
