# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.4.0] - 2026-03-18

### Added

- **`exceptionBuilder`** — optional callback in `SmartExecuterConfig.initialize` for custom `SmartException` creation
  - Receives the original error (`Object`), `StackTrace?`, and `ExceptionMetadata`
  - Returns a `SmartException` to override default mapping, or `null` to fall back to `ExceptionMapper`
  - Applied globally to all operations (`run`, `inBackground`, `execute`, `runStream`, `inBackgroundStream`)

## [2.3.0] - 2026-03-18

### Added

- **`scaffoldKey`** — optional `GlobalKey<ScaffoldState>` for controlling where `SnackBar`s are displayed
  - Set globally via `SmartExecuterConfig.initialize(scaffoldKey: ...)`
  - Override per-operation in `run`, `inBackground`, `runStream`, `inBackgroundStream`, and `execute`
  - Per-operation value takes priority over the global config
  - Useful when the calling context is not under a `ScaffoldMessenger`

## [2.2.2] - 2026-03-18

### Added

- **`defaultViewType`** in `SmartExecuterConfig.initialize()` — set the default `ErrorViewType` for all operations globally
  - Defaults to `ErrorViewType.snackBar`
  - Per-operation `viewType` overrides the global default
  - Resolution: per-operation `viewType` → `config.defaultViewType`

### Changed

- `viewType` parameter in `execute()`, `run()`, `inBackground()`, `runStream()`, `inBackgroundStream()` is now optional (`ErrorViewType?`) — if omitted, falls back to `config.defaultViewType`

## [2.2.1] - 2026-03-11

### Changed

- **BREAKING**: `MessageBuilder` typedef changed from `String Function()` to `String Function(BuildContext context)`
  - Message functions now receive the `BuildContext` for proper localization support
  - Migrate: `defaultErrorMessage: () => 'msg'` → `defaultErrorMessage: (_) => 'msg'`
  - Localization example: `noConnectionMessage: (context) => AppLocalizations.of(context)!.noConnection`
  - Config accessors changed from getters to methods: `config.noConnectionMessage` → `config.noConnectionMessage(context)`

## [2.2.0] - 2026-03-11

### Changed

- **BREAKING**: `defaultErrorMessage`, `noConnectionMessage`, `sessionExpiredTitle`, `sessionExpiredMessage` in `SmartExecuterConfig.initialize()` are now `String Function()` (`MessageBuilder`) instead of `String`
  - Enables dynamic / localized messages resolved at the time the error occurs
  - Migrate: `defaultErrorMessage: 'msg'` → `defaultErrorMessage: () => 'msg'`
  - Localization example: `noConnectionMessage: () => AppLocalizations.of(ctx)!.noConnection`
  - Getters (`config.noConnectionMessage`, etc.) still return `String` — no changes needed in call sites

### Added

- **`MessageBuilder` typedef** (`String Function()`) — new type alias used by the four message fields above

## [2.1.0] - 2026-03-05

### Added

- **Per-Operation Error Builders**: Override global error builders on a per-call basis
  - Added optional `snackBarErrorBuilder` parameter to `execute()`, `run()`, `inBackground()`, `runStream()`, `inBackgroundStream()`
  - Added optional `dialogErrorBuilder` parameter to `execute()`, `run()`, `inBackground()`, `runStream()`, `inBackgroundStream()`
  - Per-operation builders take priority over global config: operation builder → global config → package default
  - Useful for operations that need unique error presentation without changing global configuration

- **SmartExceptionType enhanced enum**: Added `color` and `icon` fields to `SmartExceptionType`
  - Each exception type now carries its own `Color` and `IconData`
  - Simplifies building custom error UIs: `exception.exceptionType.color`, `exception.exceptionType.icon`

- **Example Pages**: New interactive example pages for error builders
  - SnackBar Error Builder page with per-type trigger demos
  - Dialog Error Builder page with per-type trigger demos
  - Per-operation builder override demonstration
  - Toggle between default and custom builders
  - Configuration code previews

## [2.0.0] - 2025-03-05

### Added

- **Error Builders**: New per-exception-type error builder system
  - `SnackBarErrorBuilder` - Configure custom SnackBars for each exception type
  - `DialogErrorBuilder` - Configure custom Dialogs for each exception type
  - Both support: `baseBuilder`, per-type builders (`connectionBuilder`, `connectionTimeoutBuilder`, `sendTimeoutBuilder`, `receiveTimeoutBuilder`, `cancelledBuilder`, `responseBuilder`, `sessionExpiredBuilder`), and `customBuilder` for unknown types
  - All builders receive full `SmartException` with `ExceptionMetadata`

- **Error View Types**: New `ErrorViewType` enum (`snackBar`, `dialog`)
  - Added `viewType` parameter to `run()`, `inBackground()`, `runStream()`, `inBackgroundStream()`
  - Added optional `context` and `viewType` to `execute()` for visual error display
  - Default view type is `ErrorViewType.snackBar`

- **SmartErrorDialog**: New default error dialog widget
  - Modern Material 3 design with colored icon circle
  - Per-exception-type icons, colors, and titles
  - Rounded corners with styled action button

- **SmartExceptionType enum**: New `SmartExceptionType` enum for convenient exception type identification
  - Each `SmartException` subclass now has an `exceptionType` getter
  - Enables simple type checking without pattern matching: `exception.exceptionType == SmartExceptionType.connection`

- **Enhanced SmartErrorSnackBar**: Upgraded default design
  - Distinct icons per error type (`wifi_off`, `timer_off`, `upload`, `download`, `cancel`, `cloud_off`, `lock_outline`, `error_outline`)
  - Improved rounded corners and elevation

### Changed

- **BREAKING**: `SmartExecuterConfig.initialize()` now uses `snackBarErrorBuilder` (type `SnackBarErrorBuilder`) and `dialogErrorBuilder` (type `DialogErrorBuilder`) instead of `errorSnackBarBuilder` (type `ErrorSnackBarBuilder`)
- **BREAKING**: Removed `ErrorSnackBarBuilder` typedef from config

### Removed

- **BREAKING**: Removed auto-retry mechanism entirely
  - Removed `maxRetries` and `retryDelay` from `SmartExecuterConfig.initialize()`
  - Removed `maxRetries` and `retryDelay` from `ExecuterOptions`
  - Removed retry loop from `SmartExecuter.execute()`

## [1.4.0] - 2025-01-01

### Added

- **Real-World Integration Scenarios**: Example app now includes comprehensive scenarios demonstrating integration with Genius Systems packages:
  - **User List Scenario**: SmartPagination + SmartExecuter for paginated lists with error handling
  - **Form Submit Scenario**: SuperDialog + SmartExecuter for form workflows with confirmation dialogs
  - **Product Cards Scenario**: TooltipCard + SmartExecuter for interactive product cards
  - **Full Integration Scenario**: Complete task dashboard combining all packages

- **New Dependencies** (example app):
  - `smart_pagination: ^2.5.0` - Paginated lists with BLoC
  - `super_dialog: ^0.3.0` - Animated dialogs
  - `tooltip_card: ^2.6.1` - Interactive tooltips

### Changed

- Enhanced example app with Real-World Scenarios section on home page
- Added scenarios folder with integration examples
- Improved documentation with code previews

## [1.3.0] - 2024-01-01

### Added

- **Status Cards Customization**: Full widget customization support
  - `titleWidget` - Custom widget for title (overrides `title` text)
  - `bodyWidget` - Custom widget for body (overrides `message` text)
  - `actionsWidget` - Custom widget for actions (overrides `action`/`secondaryAction`)
  - `iconWidget` - Custom widget for icon (overrides `icon`)
  - `showCloseButton` - Option to show/hide close button
  - `onClose` - Callback when close button is pressed
  - `closeButtonColor` - Custom close button color

- **SmartLoadingCard Customization**:
  - `titleWidget` - Custom title widget
  - `bodyWidget` - Custom body widget
  - `indicatorWidget` - Custom loading indicator widget
  - `showCloseButton` - Close button support

### Changed

- Enhanced example app with custom widget demonstrations
- Status cards now support both text-based and widget-based content

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
