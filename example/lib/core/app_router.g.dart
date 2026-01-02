// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'basic-usage',
          factory: $BasicUsageRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'status-cards',
          factory: $StatusCardsRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'loading-dialogs',
          factory: $LoadingDialogsRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'exception-handling',
          factory: $ExceptionHandlingRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'scenarios/user-list',
          factory: $UserListRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'scenarios/form-submit',
          factory: $FormSubmitRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'scenarios/product-cards',
          factory: $ProductCardsRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'scenarios/full-integration',
          factory: $FullIntegrationRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples',
          factory: $ExamplesGalleryRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/sequential',
          factory: $SequentialExecutionRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/parallel',
          factory: $ParallelExecutionRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/debounce-throttle',
          factory: $DebounceThrottleRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/auto-retry',
          factory: $AutoRetryRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/pull-refresh',
          factory: $PullToRefreshRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/optimistic',
          factory: $OptimisticUpdateRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/skeleton',
          factory: $SkeletonLoadingRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/offline',
          factory: $OfflineModeRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'examples/crud',
          factory: $CrudOperationsRoute._fromState,
        ),
      ],
    );

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location(
        '/',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BasicUsageRoute on GoRouteData {
  static BasicUsageRoute _fromState(GoRouterState state) =>
      const BasicUsageRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic-usage',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StatusCardsRoute on GoRouteData {
  static StatusCardsRoute _fromState(GoRouterState state) =>
      const StatusCardsRoute();

  @override
  String get location => GoRouteData.$location(
        '/status-cards',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LoadingDialogsRoute on GoRouteData {
  static LoadingDialogsRoute _fromState(GoRouterState state) =>
      const LoadingDialogsRoute();

  @override
  String get location => GoRouteData.$location(
        '/loading-dialogs',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExceptionHandlingRoute on GoRouteData {
  static ExceptionHandlingRoute _fromState(GoRouterState state) =>
      const ExceptionHandlingRoute();

  @override
  String get location => GoRouteData.$location(
        '/exception-handling',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UserListRoute on GoRouteData {
  static UserListRoute _fromState(GoRouterState state) => UserListRoute(
        initialPage: _$convertMapValue(
            'initial-page', state.uri.queryParameters, int.tryParse),
        pageSize: _$convertMapValue(
            'page-size', state.uri.queryParameters, int.tryParse),
      );

  UserListRoute get _self => this as UserListRoute;

  @override
  String get location => GoRouteData.$location(
        '/scenarios/user-list',
        queryParams: {
          if (_self.initialPage != null)
            'initial-page': _self.initialPage!.toString(),
          if (_self.pageSize != null) 'page-size': _self.pageSize!.toString(),
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FormSubmitRoute on GoRouteData {
  static FormSubmitRoute _fromState(GoRouterState state) => FormSubmitRoute(
        prefilledName: state.uri.queryParameters['prefilled-name'],
        prefilledEmail: state.uri.queryParameters['prefilled-email'],
      );

  FormSubmitRoute get _self => this as FormSubmitRoute;

  @override
  String get location => GoRouteData.$location(
        '/scenarios/form-submit',
        queryParams: {
          if (_self.prefilledName != null)
            'prefilled-name': _self.prefilledName,
          if (_self.prefilledEmail != null)
            'prefilled-email': _self.prefilledEmail,
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProductCardsRoute on GoRouteData {
  static ProductCardsRoute _fromState(GoRouterState state) => ProductCardsRoute(
        category: state.uri.queryParameters['category'],
        sortBy: state.uri.queryParameters['sort-by'],
      );

  ProductCardsRoute get _self => this as ProductCardsRoute;

  @override
  String get location => GoRouteData.$location(
        '/scenarios/product-cards',
        queryParams: {
          if (_self.category != null) 'category': _self.category,
          if (_self.sortBy != null) 'sort-by': _self.sortBy,
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FullIntegrationRoute on GoRouteData {
  static FullIntegrationRoute _fromState(GoRouterState state) =>
      FullIntegrationRoute(
        tab: _$convertMapValue('tab', state.uri.queryParameters, int.tryParse),
        userId: state.uri.queryParameters['user-id'],
      );

  FullIntegrationRoute get _self => this as FullIntegrationRoute;

  @override
  String get location => GoRouteData.$location(
        '/scenarios/full-integration',
        queryParams: {
          if (_self.tab != null) 'tab': _self.tab!.toString(),
          if (_self.userId != null) 'user-id': _self.userId,
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExamplesGalleryRoute on GoRouteData {
  static ExamplesGalleryRoute _fromState(GoRouterState state) =>
      const ExamplesGalleryRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SequentialExecutionRoute on GoRouteData {
  static SequentialExecutionRoute _fromState(GoRouterState state) =>
      const SequentialExecutionRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/sequential',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ParallelExecutionRoute on GoRouteData {
  static ParallelExecutionRoute _fromState(GoRouterState state) =>
      const ParallelExecutionRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/parallel',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DebounceThrottleRoute on GoRouteData {
  static DebounceThrottleRoute _fromState(GoRouterState state) =>
      const DebounceThrottleRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/debounce-throttle',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AutoRetryRoute on GoRouteData {
  static AutoRetryRoute _fromState(GoRouterState state) =>
      const AutoRetryRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/auto-retry',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PullToRefreshRoute on GoRouteData {
  static PullToRefreshRoute _fromState(GoRouterState state) =>
      const PullToRefreshRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/pull-refresh',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OptimisticUpdateRoute on GoRouteData {
  static OptimisticUpdateRoute _fromState(GoRouterState state) =>
      const OptimisticUpdateRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/optimistic',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SkeletonLoadingRoute on GoRouteData {
  static SkeletonLoadingRoute _fromState(GoRouterState state) =>
      const SkeletonLoadingRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/skeleton',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OfflineModeRoute on GoRouteData {
  static OfflineModeRoute _fromState(GoRouterState state) =>
      const OfflineModeRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/offline',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CrudOperationsRoute on GoRouteData {
  static CrudOperationsRoute _fromState(GoRouterState state) =>
      const CrudOperationsRoute();

  @override
  String get location => GoRouteData.$location(
        '/examples/crud',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}
