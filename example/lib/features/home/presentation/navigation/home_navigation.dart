import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_executer_example/app/routing/route_paths.dart';

/// Navigation commands required by the home view.
///
/// Shared path constants keep the feature independent from route
/// implementation classes and prevent a router <-> home import cycle.
extension HomeNavigationX on BuildContext {
  void goToBasicUsage() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.basicUsage));

  void goToStatusCards() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.statusCards));

  void goToLoadingDialogs() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.loadingDialogs));

  void goToExceptionHandling() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.exceptionHandling));

  void goToUserList() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.userList));

  void goToFormSubmit() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.formSubmit));

  void goToProductCards() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.productCards));

  void goToFullIntegration() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.fullIntegration));

  void goToSequentialExecution() => GoRouter.of(this)
      .go(RoutePaths.location(RoutePaths.sequentialExecution));

  void goToParallelExecution() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.parallelExecution));

  void goToDebounceThrottle() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.debounceThrottle));

  void goToAutoRetry() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.autoRetry));

  void goToPullToRefresh() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.pullToRefresh));

  void goToOptimisticUpdate() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.optimisticUpdate));

  void goToSkeletonLoading() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.skeletonLoading));

  void goToOfflineMode() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.offlineMode));

  void goToCrudOperations() =>
      GoRouter.of(this).go(RoutePaths.location(RoutePaths.crudOperations));

  void goToSnackBarErrorBuilder() => GoRouter.of(this)
      .go(RoutePaths.location(RoutePaths.snackBarErrorBuilder));

  void goToDialogErrorBuilder() => GoRouter.of(this)
      .go(RoutePaths.location(RoutePaths.dialogErrorBuilder));
}
