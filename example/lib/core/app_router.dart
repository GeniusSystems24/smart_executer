import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/basic_usage_page.dart';
import '../pages/exception_handling_page.dart';
import '../home_page.dart';
import '../pages/loading_dialogs_page.dart';
import '../pages/status_cards_page.dart';
import '../pages/scenarios/form_submit_scenario.dart';
import '../pages/scenarios/full_integration_scenario.dart';
import '../pages/scenarios/product_cards_scenario.dart';
import '../pages/scenarios/user_list_scenario.dart';
import '../pages/examples/examples.dart';
import '../pages/examples/examples_gallery_page.dart';

part 'app_router.g.dart';

// ============================================================================
// Home Route
// ============================================================================

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    // Feature Pages
    TypedGoRoute<BasicUsageRoute>(path: 'basic-usage'),
    TypedGoRoute<StatusCardsRoute>(path: 'status-cards'),
    TypedGoRoute<LoadingDialogsRoute>(path: 'loading-dialogs'),
    TypedGoRoute<ExceptionHandlingRoute>(path: 'exception-handling'),
    // Scenario Pages
    TypedGoRoute<UserListRoute>(path: 'scenarios/user-list'),
    TypedGoRoute<FormSubmitRoute>(path: 'scenarios/form-submit'),
    TypedGoRoute<ProductCardsRoute>(path: 'scenarios/product-cards'),
    TypedGoRoute<FullIntegrationRoute>(path: 'scenarios/full-integration'),
    // Examples Gallery
    TypedGoRoute<ExamplesGalleryRoute>(path: 'examples'),
    // Execution Patterns
    TypedGoRoute<SequentialExecutionRoute>(path: 'examples/sequential'),
    TypedGoRoute<ParallelExecutionRoute>(path: 'examples/parallel'),
    TypedGoRoute<DebounceThrottleRoute>(path: 'examples/debounce-throttle'),
    // Retry Patterns
    TypedGoRoute<AutoRetryRoute>(path: 'examples/auto-retry'),
    // UI Patterns
    TypedGoRoute<PullToRefreshRoute>(path: 'examples/pull-refresh'),
    TypedGoRoute<OptimisticUpdateRoute>(path: 'examples/optimistic'),
    TypedGoRoute<SkeletonLoadingRoute>(path: 'examples/skeleton'),
    // Connectivity
    TypedGoRoute<OfflineModeRoute>(path: 'examples/offline'),
    // Data Management
    TypedGoRoute<CrudOperationsRoute>(path: 'examples/crud'),
    // Error Builders
    TypedGoRoute<SnackBarErrorBuilderRoute>(path: 'examples/snackbar-builder'),
    TypedGoRoute<DialogErrorBuilderRoute>(path: 'examples/dialog-builder'),
    TypedGoRoute<ScaffoldKeyRoute>(path: 'examples/scaffold-key'),
    TypedGoRoute<ExceptionBuilderRoute>(path: 'examples/exception-builder'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

// ============================================================================
// Feature Pages Routes
// ============================================================================

/// Basic Usage Page Route
class BasicUsageRoute extends GoRouteData with $BasicUsageRoute {
  const BasicUsageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BasicUsagePage();
  }
}

/// Status Cards Page Route
class StatusCardsRoute extends GoRouteData with $StatusCardsRoute {
  const StatusCardsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StatusCardsPage();
  }
}

/// Loading Dialogs Page Route
class LoadingDialogsRoute extends GoRouteData with $LoadingDialogsRoute {
  const LoadingDialogsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoadingDialogsPage();
  }
}

/// Exception Handling Page Route
class ExceptionHandlingRoute extends GoRouteData with $ExceptionHandlingRoute {
  const ExceptionHandlingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ExceptionHandlingPage();
  }
}

// ============================================================================
// Scenario Pages Routes
// ============================================================================

/// User List Scenario Route - demonstrates SmartPagination integration
class UserListRoute extends GoRouteData with $UserListRoute {
  const UserListRoute({
    this.initialPage,
    this.pageSize,
  });

  /// Optional initial page to start from
  final int? initialPage;

  /// Optional page size for pagination
  final int? pageSize;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserListScenario(
      key: ValueKey('user-list-$initialPage-$pageSize'),
    );
  }
}

/// Form Submit Scenario Route - demonstrates SuperDialog integration
class FormSubmitRoute extends GoRouteData with $FormSubmitRoute {
  const FormSubmitRoute({
    this.prefilledName,
    this.prefilledEmail,
  });

  /// Optional prefilled name for the form
  final String? prefilledName;

  /// Optional prefilled email for the form
  final String? prefilledEmail;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FormSubmitScenario(
      key: ValueKey('form-submit-$prefilledName-$prefilledEmail'),
    );
  }
}

/// Product Cards Scenario Route - demonstrates TooltipCard integration
class ProductCardsRoute extends GoRouteData with $ProductCardsRoute {
  const ProductCardsRoute({
    this.category,
    this.sortBy,
  });

  /// Optional category filter
  final String? category;

  /// Optional sort criteria
  final String? sortBy;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductCardsScenario(
      key: ValueKey('product-cards-$category-$sortBy'),
    );
  }
}

/// Full Integration Scenario Route - demonstrates all packages combined
class FullIntegrationRoute extends GoRouteData with $FullIntegrationRoute {
  const FullIntegrationRoute({
    this.tab,
    this.userId,
  });

  /// Optional tab index to navigate to
  final int? tab;

  /// Optional user ID to show details for
  final String? userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FullIntegrationScenario(
      key: ValueKey('full-integration-$tab-$userId'),
    );
  }
}

// ============================================================================
// Examples Routes
// ============================================================================

/// Examples Gallery Route
class ExamplesGalleryRoute extends GoRouteData with $ExamplesGalleryRoute {
  const ExamplesGalleryRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExamplesGalleryPage();
}

/// Sequential Execution Route
class SequentialExecutionRoute extends GoRouteData
    with $SequentialExecutionRoute {
  const SequentialExecutionRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SequentialExecutionPage();
}

/// Parallel Execution Route
class ParallelExecutionRoute extends GoRouteData with $ParallelExecutionRoute {
  const ParallelExecutionRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ParallelExecutionPage();
}

/// Debounce Throttle Route
class DebounceThrottleRoute extends GoRouteData with $DebounceThrottleRoute {
  const DebounceThrottleRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DebounceThrottlePage();
}

/// Auto Retry Route
class AutoRetryRoute extends GoRouteData with $AutoRetryRoute {
  const AutoRetryRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AutoRetryPage();
}

/// Pull To Refresh Route
class PullToRefreshRoute extends GoRouteData with $PullToRefreshRoute {
  const PullToRefreshRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PullToRefreshPage();
}

/// Optimistic Update Route
class OptimisticUpdateRoute extends GoRouteData with $OptimisticUpdateRoute {
  const OptimisticUpdateRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OptimisticUpdatePage();
}

/// Skeleton Loading Route
class SkeletonLoadingRoute extends GoRouteData with $SkeletonLoadingRoute {
  const SkeletonLoadingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SkeletonLoadingPage();
}

/// Offline Mode Route
class OfflineModeRoute extends GoRouteData with $OfflineModeRoute {
  const OfflineModeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OfflineModePage();
}

/// CRUD Operations Route
class CrudOperationsRoute extends GoRouteData with $CrudOperationsRoute {
  const CrudOperationsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CrudOperationsPage();
}

/// SnackBar Error Builder Route
class SnackBarErrorBuilderRoute extends GoRouteData
    with $SnackBarErrorBuilderRoute {
  const SnackBarErrorBuilderRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SnackBarErrorBuilderPage();
}

/// Dialog Error Builder Route
class DialogErrorBuilderRoute extends GoRouteData
    with $DialogErrorBuilderRoute {
  const DialogErrorBuilderRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DialogErrorBuilderPage();
}

/// Scaffold Key Route
class ScaffoldKeyRoute extends GoRouteData with $ScaffoldKeyRoute {
  const ScaffoldKeyRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ScaffoldKeyPage();
}

/// Exception Builder Route
class ExceptionBuilderRoute extends GoRouteData with $ExceptionBuilderRoute {
  const ExceptionBuilderRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExceptionBuilderPage();
}

// ============================================================================
// Router Configuration
// ============================================================================

/// The main app router instance
final GoRouter appRouter = GoRouter(
  routes: $appRoutes,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorRoute(
    error: state.error,
    fromPath: state.uri.toString(),
  ).build(context, state),
);

/// Error Route for handling navigation errors
class ErrorRoute extends GoRouteData {
  const ErrorRoute({
    required this.error,
    required this.fromPath,
  });

  final GoException? error;
  final String fromPath;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Error'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => const HomeRoute().go(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Could not navigate to: $fromPath',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Error: ${error!.message}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => const HomeRoute().go(context),
                icon: const Icon(Icons.home),
                label: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Router Location Helpers
// ============================================================================

/// Extension to get current route information from context
extension RouterLocationX on BuildContext {
  /// Get the current route location
  String get currentLocation => GoRouterState.of(this).uri.toString();

  /// Get the current route name
  String? get currentRouteName => GoRouterState.of(this).name;

  /// Get path parameters from the current route
  Map<String, String> get pathParameters =>
      GoRouterState.of(this).pathParameters;

  /// Get query parameters from the current route
  Map<String, String> get queryParameters =>
      GoRouterState.of(this).uri.queryParameters;

  /// Check if the current route matches a path
  bool isCurrentRoute(String path) => currentLocation.startsWith(path);

  /// Navigate back to home
  void goHome() => const HomeRoute().go(this);

  /// Navigate to Basic Usage
  void goToBasicUsage() => const BasicUsageRoute().go(this);

  /// Navigate to Status Cards
  void goToStatusCards() => const StatusCardsRoute().go(this);

  /// Navigate to Loading Dialogs
  void goToLoadingDialogs() => const LoadingDialogsRoute().go(this);

  /// Navigate to Exception Handling
  void goToExceptionHandling() => const ExceptionHandlingRoute().go(this);

  /// Navigate to User List Scenario
  void goToUserList({int? initialPage, int? pageSize}) =>
      UserListRoute(initialPage: initialPage, pageSize: pageSize).go(this);

  /// Navigate to Form Submit Scenario
  void goToFormSubmit({String? prefilledName, String? prefilledEmail}) =>
      FormSubmitRoute(
              prefilledName: prefilledName, prefilledEmail: prefilledEmail)
          .go(this);

  /// Navigate to Product Cards Scenario
  void goToProductCards({String? category, String? sortBy}) =>
      ProductCardsRoute(category: category, sortBy: sortBy).go(this);

  /// Navigate to Full Integration Scenario
  void goToFullIntegration({int? tab, String? userId}) =>
      FullIntegrationRoute(tab: tab, userId: userId).go(this);

  // ============================================================================
  // Examples Navigation
  // ============================================================================

  /// Navigate to Examples Gallery
  void goToExamplesGallery() => const ExamplesGalleryRoute().go(this);

  /// Navigate to Sequential Execution Example
  void goToSequentialExecution() => const SequentialExecutionRoute().go(this);

  /// Navigate to Parallel Execution Example
  void goToParallelExecution() => const ParallelExecutionRoute().go(this);

  /// Navigate to Debounce Throttle Example
  void goToDebounceThrottle() => const DebounceThrottleRoute().go(this);

  /// Navigate to Auto Retry Example
  void goToAutoRetry() => const AutoRetryRoute().go(this);

  /// Navigate to Pull To Refresh Example
  void goToPullToRefresh() => const PullToRefreshRoute().go(this);

  /// Navigate to Optimistic Update Example
  void goToOptimisticUpdate() => const OptimisticUpdateRoute().go(this);

  /// Navigate to Skeleton Loading Example
  void goToSkeletonLoading() => const SkeletonLoadingRoute().go(this);

  /// Navigate to Offline Mode Example
  void goToOfflineMode() => const OfflineModeRoute().go(this);

  /// Navigate to CRUD Operations Example
  void goToCrudOperations() => const CrudOperationsRoute().go(this);

  /// Navigate to SnackBar Error Builder Example
  void goToSnackBarErrorBuilder() =>
      const SnackBarErrorBuilderRoute().go(this);

  /// Navigate to Dialog Error Builder Example
  void goToDialogErrorBuilder() =>
      const DialogErrorBuilderRoute().go(this);

  /// Navigate to Scaffold Key Example
  void goToScaffoldKey() => const ScaffoldKeyRoute().go(this);

  /// Navigate to Exception Builder Example
  void goToExceptionBuilder() => const ExceptionBuilderRoute().go(this);
}

// ============================================================================
// Route Information Widget
// ============================================================================

/// A widget that displays current route information for debugging
class RouteInfoBanner extends StatelessWidget {
  const RouteInfoBanner({super.key, this.showParameters = true});

  final bool showParameters;

  @override
  Widget build(BuildContext context) {
    final location = context.currentLocation;
    final pathParams = context.pathParameters;
    final queryParams = context.queryParameters;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (showParameters &&
              (pathParams.isNotEmpty || queryParams.isNotEmpty)) ...[
            const Divider(color: Colors.white24, height: 16),
            if (pathParams.isNotEmpty) _buildParamsRow('Path', pathParams),
            if (queryParams.isNotEmpty) _buildParamsRow('Query', queryParams),
          ],
        ],
      ),
    );
  }

  Widget _buildParamsRow(String label, Map<String, String> params) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              params.entries.map((e) => '${e.key}=${e.value}').join(', '),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
