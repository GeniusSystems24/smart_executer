/// Route segments shared by typed route declarations and presentation
/// navigation commands.
abstract final class RoutePaths {
  static const home = '/';
  static const basicUsage = 'basic-usage';
  static const statusCards = 'status-cards';
  static const loadingDialogs = 'loading-dialogs';
  static const exceptionHandling = 'exception-handling';
  static const userList = 'scenarios/user-list';
  static const formSubmit = 'scenarios/form-submit';
  static const productCards = 'scenarios/product-cards';
  static const fullIntegration = 'scenarios/full-integration';
  static const examplesGallery = 'examples';
  static const sequentialExecution = 'examples/sequential';
  static const parallelExecution = 'examples/parallel';
  static const debounceThrottle = 'examples/debounce-throttle';
  static const autoRetry = 'examples/auto-retry';
  static const pullToRefresh = 'examples/pull-refresh';
  static const optimisticUpdate = 'examples/optimistic';
  static const skeletonLoading = 'examples/skeleton';
  static const offlineMode = 'examples/offline';
  static const crudOperations = 'examples/crud';
  static const snackBarErrorBuilder = 'examples/snackbar-builder';
  static const dialogErrorBuilder = 'examples/dialog-builder';
  static const scaffoldKey = 'examples/scaffold-key';
  static const exceptionBuilder = 'examples/exception-builder';

  static String location(String segment) => '/$segment';
}
