# Smart Executer Example

This example demonstrates how to use the Smart Executer package.

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Features Demonstrated

- **Basic Usage**: Run operations with loading dialog or in background
- **Result Pattern**: Type-safe success/failure handling
- **Error Handling**: Simulate various error scenarios
- **Error Views**: Display errors as SnackBars or Dialogs with `ErrorViewType`
- **Callbacks**: Use callbacks for success and error handling
- **Connectivity**: Check network status and conditionally run requests
- **Snack Bars**: Show success, error, and custom snack bars

## Code Highlights

### Initialize Configuration

```dart
SmartExecuterConfig.initialize(
  enableLogging: kDebugMode,
  defaultErrorMessage: 'Something went wrong. Please try again.',
);
```

### Run with Loading Dialog

```dart
final result = await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
);
```

### Error View Types

```dart
// Show errors as a dialog instead of snackbar
await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
  viewType: ErrorViewType.dialog,
);
```

### Use Result Pattern

```dart
final result = await SmartExecuter.execute(
  () => dio.get('/posts/1'),
);

switch (result) {
  case Success(:final data):
    print('Got: ${data.data}');
  case Failure(:final exception):
    print('Error: ${exception.message}');
    print('Type: ${exception.exceptionType}');
}
```

### With Callbacks

```dart
await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
  onSuccess: (response) async {
    print('Success!');
  },
  onError: (exception) async {
    print('Error: ${exception.message}');
  },
);
```
