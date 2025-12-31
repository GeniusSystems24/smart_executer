# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added

- **Result Pattern**: Type-safe `Result<T>` with `Success` and `Failure` sealed classes
  - `map()`, `flatMap()`, `fold()` for functional programming style
  - `getOrElse()`, `getOrCompute()` for default values
  - `onSuccess()`, `onFailure()` for side effects

- **SmartExecuter Core Methods**:
  - `execute<T>()` - Returns `Result<T>` without UI
  - `run<T>()` - Executes with loading dialog
  - `inBackground<T>()` - Executes without UI feedback
  - `runStream<T>()` - Stream execution with progress dialog
  - `inBackgroundStream<T>()` - Silent stream execution

- **Global Configuration** (`SmartExecuterConfig`):
  - Custom loading dialog builder
  - Custom error snack bar builder
  - Global error handler
  - Session expiration handler
  - Customizable messages (error, no connection, session expired)
  - Retry configuration (max retries, delay)
  - Connection checking by default option
  - Logging toggle

- **Per-Operation Options** (`ExecuterOptions`):
  - Show/hide loading dialog
  - Check connection before request
  - Override retry settings
  - Custom timeout
  - Custom loading widget
  - Barrier dismissible option
  - Custom barrier color

- **Exception Hierarchy** (sealed classes):
  - `SmartException` - Base exception
  - `ConnectionException` - No internet connection
  - `ConnectionTimeoutException` - Connection timeout
  - `SendTimeoutException` - Request send timeout
  - `ReceiveTimeoutException` - Response receive timeout
  - `CancelledException` - Request cancelled
  - `ResponseException` - Server error (with status code)
  - `SessionExpiredException` - 401 Unauthorized
  - `UnknownException` - Unknown errors
  - `ExceptionMapper` - Converts Dio exceptions to SmartExceptions

- **Loading Dialogs**:
  - `SmartLoadingDialog` - Customizable circular progress dialog
  - `SmartProgressDialog` - Linear progress with percentage
  - `SmartLoadingOverlay` - Minimal fullscreen overlay

- **Snack Bars**:
  - `SmartErrorSnackBar` - Error display with auto-coloring
  - `SmartSuccessSnackBar` - Success message display
  - `SmartSnackBars` - Helper class for showing snack bars

- **Connectivity Utilities** (`ConnectivityChecker`):
  - `hasConnection()` - Check if connected
  - `getStatus()` - Get connection types
  - `isConnectedViaWifi()` - WiFi check
  - `isConnectedViaMobile()` - Mobile data check
  - `isConnectedViaEthernet()` - Ethernet check
  - `onConnectivityChanged` - Stream of connectivity changes

- **Retry Mechanism**:
  - Automatic retry with exponential backoff
  - Configurable max attempts and delay
  - Smart retry (skips non-retryable errors)

- **CancelToken Support**:
  - Pass Dio `CancelToken` to cancel requests
  - Proper handling of cancelled requests

### Changed

- Complete rewrite of the library architecture
- Modular file structure under `lib/src/`
- Improved error handling with sealed classes
- Removed dependency on external `ErrorInfoBar` and `AppWaitingDialog`
- All widgets now included in the package

### Removed

- Deprecated `while(true)` busy-wait loops
- Hard-coded Arabic strings (now configurable)
- External widget dependencies

## [0.0.1] - 2024-01-01

### Added

- Initial release with basic functionality
- `SmartExecuter.run()` method
- `SmartExecuter.inBackground()` method
- Basic error handling for Dio exceptions
- Waiting dialog support
