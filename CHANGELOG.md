# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-01-01

### Added

- **Status Cards**: Ready-to-use cards for displaying different states in the UI
  - `SmartErrorCard` - Error state card with `fromException()` factory
  - `SmartSuccessCard` - Success state card
  - `SmartWarningCard` - Warning state card
  - `SmartInfoCard` - Information state card
  - `SmartEmptyCard` - Empty/no data state card
  - `SmartLoadingCard` - Loading state card with progress indicator

- **Pre-configured Status Cards**:
  - `SmartOfflineCard` - No internet connection card
  - `SmartSessionExpiredCard` - Session expired card
  - `SmartTimeoutCard` - Request timeout card
  - `SmartServerErrorCard` - Server error with contact support option
  - `SmartMaintenanceCard` - Under maintenance card
  - `SmartPermissionDeniedCard` - Permission required card
  - `SmartNotFoundCard` - Resource not found (404) card

- **Enhanced Example App**:
  - Bottom navigation with 4 screens
  - Basic Usage page with all core features
  - Status Cards page showcasing all card types
  - Loading Dialogs page with interactive demos
  - Exception Handling page with error simulation

### Changed

- Improved example app structure with multiple screens
- Added metadata demonstration in example

## [1.1.0] - 2024-01-01

### Added

- **Exception Metadata Support**: Attach debugging information to exceptions
  - New `ExceptionMetadata` class with fields:
    - `operationName` - Name of the failed operation
    - `endpoint` - API endpoint (auto-extracted from Dio)
    - `requestMethod` - HTTP method (auto-extracted from Dio)
    - `userId` - User identifier for tracking
    - `sessionId` - Session identifier
    - `timestamp` - When the error occurred
    - `extra` - Custom key-value data
  - All `SmartException` subclasses now include `metadata` field
  - `withMetadata()` method to attach metadata to existing exceptions
  - `toMap()` method for easy serialization/logging

- **ExecuterOptions Metadata Fields**:
  - `operationName` - Name the operation for debugging
  - `metadata` - Attach custom data to exceptions

- **Auto-extraction from Dio**: Endpoint and HTTP method are automatically extracted from `DioException`

### Changed

- `ExceptionMapper.fromDioException()` now accepts optional metadata
- `ExceptionMapper.fromException()` now accepts optional metadata
- Logging now includes metadata when `enableLogging` is true

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
