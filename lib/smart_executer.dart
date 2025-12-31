import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// A utility class for executing asynchronous operations with enhanced error handling
/// and optional waiting dialogs.
///
/// This class provides two main methods:
/// - [run]: Executes a request with error handling and an optional waiting dialog.
/// - [inBackground]: Executes a request in the background without showing a waiting dialog.
abstract class SmartExecuter {
  static Future<T?> _run<T>({
    required Future<T?> Function() request,
    required BuildContext context,
    Future<void> Function()? onCancel,
    Future<void> Function()? onConnectionError,
    Future<void> Function()? onConnectTimeout,
    Future<void> Function()? onReceiveTimeout,
    Future<void> Function()? onSendTimeout,
    Future<void> Function()? onResponseError,
    Future<void> Function()? onOtherError,
    Future<void> Function(T result)? onSuccess,
    Future<void> Function()? onReSignIn,
    bool showWaitingDialog = true,
    bool checkConnection = false,
    Widget? waitingChild,
  }) async {
    if (checkConnection) {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (onConnectionError != null) {
          onConnectionError();
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorInfoBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: const Text("لا يوجد اتصال بالانترنت"),
              ),
            );
        }
      }
    }
    T? response;

    // Show the waiting dialog
    if (showWaitingDialog) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            waitingChild ?? const AppWaitingDialog(),
      );
    }

    try {
      // Run the action
      try {
        response = await request();
      } catch (e, stackTrace) {
        Logger().e(e, stackTrace: stackTrace);
        rethrow;
      }

      // Hide the waiting dialog
      if (showWaitingDialog) {
        while (true) {
          if ((context).mounted) {
            Navigator.of(context).pop(response);
            break;
          }
        }
      }

      // Run the onSuccess function if provided
      if (onSuccess != null && response != null) {
        onSuccess(response);
      }
      return response;
    } on DioException catch (e) {
      // Hide the waiting dialog
      if (showWaitingDialog) {
        while (true) {
          if ((context).mounted) {
            Navigator.of(context).pop();
            break;
          }
        }
      }
      switch (e.type) {
        case DioExceptionType.cancel:
          if (onCancel != null) onCancel();
          break;
        case DioExceptionType.connectionTimeout:
          if (onConnectTimeout != null) onConnectTimeout();
          break;
        case DioExceptionType.receiveTimeout:
          if (onReceiveTimeout != null) onReceiveTimeout();
          break;
        case DioExceptionType.sendTimeout:
          if (onSendTimeout != null) onSendTimeout();
          break;
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 401 && onReSignIn != null) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Session Expired'),
                  content: const Text(
                    'Your session has expired. Please sign in again.',
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onReSignIn();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (onResponseError != null) {
            onResponseError();
          }
          break;
        default:
          if (onOtherError != null) onOtherError();
          break;
      }

      // Show the error message in an info bar
      while (true) {
        if ((context).mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorInfoBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: Text(
                  e.response?.data?.toString() ?? e.message?.toString() ?? "",
                ),
              ),
            );
          break;
        }
      }
    } catch (e) {
      // Hide the waiting dialog
      if (showWaitingDialog) {
        while (true) {
          if ((context).mounted) {
            Navigator.of(context).pop();
            break;
          }
        }
      }
      // Logger().e(e);
      // Show the error message in an info bar
      while (true) {
        if ((context).mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorInfoBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: Text(e.toString()),
              ),
            );
          break;
        }
      }

      // Run the onOtherError function if provided
      if (onOtherError != null) {
        onOtherError();
      }
    }

    // Return the response
    return response;
  }

  /// Runs an asynchronous request with optional error handling and waiting dialog.
  ///
  /// **Parameters:**
  /// - [request]: The asynchronous request to be executed.
  /// - [onCancel]: Callback when the request is canceled.
  /// - [onConnectTimeout]: Callback when there is a connection timeout.
  /// - [onReceiveTimeout]: Callback when there is a receive timeout.
  /// - [onSendTimeout]: Callback when there is a send timeout.
  /// - [onResponseError]: Callback when there is an error in the server response.
  /// - [onOtherError]: Callback when an unknown error occurs.
  /// - [onSuccess]: Callback executed when the request is successful.
  /// - [onReSignIn]: Callback when session re-authentication is required.
  /// - [showWaitingDialog]: Determines whether to show a waiting dialog during the request.
  /// - [waitingChild]: A custom widget displayed in the waiting dialog.
  ///
  /// **Returns:** The result of the asynchronous request, if successful.
  ///
  /// **Example Usage:**
  /// ```dart
  /// await SmartExecuter.run<String>(
  ///   () async {
  ///     return await apiService.fetchData();
  ///   },
  ///   onSuccess: (result) {
  ///     print('Success: $result');
  ///   },
  ///   onCancel: () {
  ///     print('Request was canceled');
  ///   },
  ///   onConnectTimeout: () {
  ///     print('Connection timeout occurred');
  ///   },
  ///   onResponseError: () {
  ///     print('Response error occurred');
  ///   },
  ///   onOtherError: () {
  ///     print('An unknown error occurred');
  ///   },
  ///   onReSignIn: () {
  ///     print('User needs to re-authenticate');
  ///   },
  ///   waitingChild: CircularProgressIndicator(),
  /// );
  /// ```
  ///
  /// **Error Handling:**
  /// - DioException (e.g., network errors, timeouts)
  /// - General exceptions
  ///
  static Future<T?> run<T extends Object>({
    required Future<T?> Function() request,
    required BuildContext context,
    Future<void> Function()? onCancel,
    Future<void> Function()? onConnectionError,
    Future<void> Function()? onConnectTimeout,
    Future<void> Function()? onReceiveTimeout,
    Future<void> Function()? onSendTimeout,
    Future<void> Function()? onResponseError,
    Future<void> Function()? onOtherError,
    Future<void> Function(T result)? onSuccess,
    Future<void> Function()? onReSignIn,
    bool checkConnection = false,
    Widget? waitingChild,
  }) => _run(
    request: request,
    context: context,
    onCancel: onCancel,
    onConnectionError: onConnectionError,
    onConnectTimeout: onConnectTimeout,
    onReceiveTimeout: onReceiveTimeout,
    onSendTimeout: onSendTimeout,
    onResponseError: onResponseError,
    onOtherError: onOtherError,
    onSuccess: onSuccess,
    onReSignIn: onReSignIn,
    waitingChild: waitingChild,
    showWaitingDialog: true,
    checkConnection: checkConnection,
  );

  /// Runs an asynchronous request in the background without showing a waiting dialog.
  ///
  /// **Parameters:** Same as [run], but `showWaitingDialog` is always `false`.
  ///
  /// **Returns:** The result of the asynchronous request, if successful.
  ///
  /// **Example Usage:**
  /// ```dart
  /// await SmartExecuter.inBackground<String>(
  ///   () async {
  ///     return await apiService.fetchData();
  ///   },
  ///   onSuccess: (result) {
  ///     print('Background Success: $result');
  ///   },
  ///   onOtherError: () {
  ///     print('Background error occurred');
  ///   },
  ///   onCancel: () {
  ///     print('Request was canceled');
  ///   },
  ///   onConnectTimeout: () {
  ///     print('Connection timeout occurred');
  ///   },
  ///   onResponseError: () {
  ///     print('Response error occurred');
  ///   },
  ///   onReSignIn: () {
  ///     print('User needs to re-authenticate');
  ///   },
  /// );
  /// ```
  ///
  /// **Best For:**
  /// - Background operations
  /// - Silent network requests
  static Future<T?> inBackground<T>({
    required Future<T?> Function() request,
    required BuildContext context,
    Future<void> Function()? onCancel,
    Future<void> Function()? onConnectTimeout,
    Future<void> Function()? onReceiveTimeout,
    Future<void> Function()? onSendTimeout,
    Future<void> Function()? onResponseError,
    Future<void> Function()? onOtherError,
    Future<void> Function(T result)? onSuccess,
    Future<void> Function()? onReSignIn,
    Widget? waitingChild,
  }) => _run(
    request: request,
    context: context,
    onCancel: onCancel,
    onConnectTimeout: onConnectTimeout,
    onReceiveTimeout: onReceiveTimeout,
    onSendTimeout: onSendTimeout,
    onResponseError: onResponseError,
    onOtherError: onOtherError,
    onSuccess: onSuccess,
    onReSignIn: onReSignIn,
    showWaitingDialog: false,
    waitingChild: waitingChild,
  );

  static Future<StreamType?> _runStream<StreamType>({
    required Stream<StreamType?> Function() requestStream,
    required BuildContext context,
    Future<void> Function()? onCancel,
    Future<void> Function()? onConnectionError,
    Future<void> Function()? onConnectTimeout,
    Future<void> Function()? onReceiveTimeout,
    Future<void> Function()? onSendTimeout,
    Future<void> Function()? onResponseError,
    Future<void> Function()? onOtherError,
    Future<void> Function(StreamType result)? onSuccess,
    Future<void> Function()? onReSignIn,
    bool showWaitingDialog = true,
    bool checkConnection = false,
    Widget Function(BuildContext context, StreamType value)? waitingBuilder,
    void Function(StreamType? value)? listener,
  }) async {
    if (checkConnection) {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (onConnectionError != null) {
          onConnectionError();
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorInfoBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: const Text("لا يوجد اتصال بالانترنت"),
              ),
            );
        }
      }
    }
    final ValueNotifier<StreamType?> streamValue = ValueNotifier(null);

    // Show the waiting dialog
    if (showWaitingDialog) {
      await showDialog<StreamType>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ValueListenableBuilder(
          valueListenable: streamValue,
          builder: (context, value, child) {
            if (waitingBuilder == null || value == null)
              return const AppWaitingDialog();
            return waitingBuilder(context, value);
          },
        ),
      );
    }

    try {
      dynamic error;

      // Run the action
      requestStream()
          .listen((event) {
            listener?.call(event);
            streamValue.value = event;
          })
          .onError((ero) {
            error = ero;
            throw ero;
          });

      while (streamValue.value == null) {
        if (error != null) throw error;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final response = streamValue.value;
      // Hide the waiting dialog
      if (showWaitingDialog) {
        while (true) {
          if ((context).mounted) {
            Navigator.of(context).pop(response);
            break;
          }
        }
      }

      // Run the onSuccess function if provided
      if (onSuccess != null && response != null) {
        onSuccess(response);
      }
      return response;
    } on DioException catch (e) {
      // Hide the waiting dialog
      if (showWaitingDialog) {
        while (true) {
          if ((context).mounted) {
            Navigator.of(context).pop();
            break;
          }
        }
      }
      switch (e.type) {
        case DioExceptionType.cancel:
          if (onCancel != null) onCancel();
          break;
        case DioExceptionType.connectionTimeout:
          if (onConnectTimeout != null) onConnectTimeout();
          break;
        case DioExceptionType.receiveTimeout:
          if (onReceiveTimeout != null) onReceiveTimeout();
          break;
        case DioExceptionType.sendTimeout:
          if (onSendTimeout != null) onSendTimeout();
          break;
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 401 && onReSignIn != null) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Session Expired'),
                  content: const Text(
                    'Your session has expired. Please sign in again.',
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onReSignIn();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (onResponseError != null) {
            onResponseError();
          }
          break;
        default:
          if (onOtherError != null) onOtherError();
          break;
      }

      // Show the error message in an info bar
      while (true) {
        if ((context).mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorInfoBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: Text(e.response?.data ?? e.message ?? ""),
              ),
            );
          break;
        }
      }
    } catch (e, stackTrace) {
      // Hide the waiting dialog
      Logger().e("Error in _runStream: $e", stackTrace: stackTrace);
      if (showWaitingDialog) {
        while (true) {
          if ((context).mounted) {
            Navigator.of(context).pop();
            break;
          }
        }
      }
      // Logger().e(e);
      // Show the error message in an info bar
      while (true) {
        if ((context).mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorInfoBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                content: Text(e.toString()),
              ),
            );
          break;
        }
      }

      // Run the onOtherError function if provided
      if (onOtherError != null) {
        onOtherError();
      }
    }

    // Return the response
    return streamValue.value;
  }

  /// Runs an asynchronous request with optional error handling and waiting dialog.
  ///
  /// **Parameters:**
  /// - [requestStream]: The asynchronous request to be executed.
  /// - [onCancel]: Callback when the request is canceled.
  /// - [onConnectTimeout]: Callback when there is a connection timeout.
  /// - [onReceiveTimeout]: Callback when there is a receive timeout.
  /// - [onSendTimeout]: Callback when there is a send timeout.
  /// - [onResponseError]: Callback when there is an error in the server response.
  /// - [onOtherError]: Callback when an unknown error occurs.
  /// - [onSuccess]: Callback executed when the request is successful.
  /// - [onReSignIn]: Callback when session re-authentication is required.
  /// - [showWaitingDialog]: Determines whether to show a waiting dialog during the request.
  /// - [waitingChild]: A custom widget displayed in the waiting dialog.
  ///
  /// **Returns:** The result of the asynchronous request, if successful.
  ///
  /// **Example Usage:**
  /// ```dart
  /// await SmartExecuter.run<String>(
  ///   () async {
  ///     return await apiService.fetchData();
  ///   },
  ///   onSuccess: (result) {
  ///     print('Success: $result');
  ///   },
  ///   onCancel: () {
  ///     print('Request was canceled');
  ///   },
  ///   onConnectTimeout: () {
  ///     print('Connection timeout occurred');
  ///   },
  ///   onResponseError: () {
  ///     print('Response error occurred');
  ///   },
  ///   onOtherError: () {
  ///     print('An unknown error occurred');
  ///   },
  ///   onReSignIn: () {
  ///     print('User needs to re-authenticate');
  ///   },
  ///   waitingChild: CircularProgressIndicator(),
  /// );
  /// ```
  ///
  /// **Error Handling:**
  /// - DioException (e.g., network errors, timeouts)
  /// - General exceptions
  ///
  static Future<StreamType?> runStream<StreamType extends Object>({
    required Stream<StreamType?> Function() requestStream,
    required BuildContext context,
    Future<void> Function()? onCancel,
    Future<void> Function()? onConnectionError,
    Future<void> Function()? onConnectTimeout,
    Future<void> Function()? onReceiveTimeout,
    Future<void> Function()? onSendTimeout,
    Future<void> Function()? onResponseError,
    Future<void> Function()? onOtherError,
    Future<void> Function(StreamType result)? onSuccess,
    Future<void> Function()? onReSignIn,
    bool checkConnection = false,
    Widget Function(BuildContext context, StreamType value)? waitingBuilder,
    void Function(StreamType? value)? listener,
  }) => _runStream(
    requestStream: requestStream,
    context: context,
    onCancel: onCancel,
    onConnectionError: onConnectionError,
    onConnectTimeout: onConnectTimeout,
    onReceiveTimeout: onReceiveTimeout,
    onSendTimeout: onSendTimeout,
    onResponseError: onResponseError,
    onOtherError: onOtherError,
    onSuccess: onSuccess,
    onReSignIn: onReSignIn,
    waitingBuilder: waitingBuilder,
    listener: listener,
    showWaitingDialog: true,
    checkConnection: checkConnection,
  );

  /// Runs an asynchronous request in the background without showing a waiting dialog.
  ///
  /// **Parameters:** Same as [run], but `showWaitingDialog` is always `false`.
  ///
  /// **Returns:** The result of the asynchronous request, if successful.
  ///
  /// **Example Usage:**
  /// ```dart
  /// await SmartExecuter.inBackground<String>(
  ///   () async {
  ///     return await apiService.fetchData();
  ///   },
  ///   onSuccess: (result) {
  ///     print('Background Success: $result');
  ///   },
  ///   onOtherError: () {
  ///     print('Background error occurred');
  ///   },
  ///   onCancel: () {
  ///     print('Request was canceled');
  ///   },
  ///   onConnectTimeout: () {
  ///     print('Connection timeout occurred');
  ///   },
  ///   onResponseError: () {
  ///     print('Response error occurred');
  ///   },
  ///   onReSignIn: () {
  ///     print('User needs to re-authenticate');
  ///   },
  /// );
  /// ```
  ///
  /// **Best For:**
  /// - Background operations
  /// - Silent network requests
  static Future<StreamType?> inBackgroundStream<StreamType>({
    required Stream<StreamType?> Function() requestStream,
    required BuildContext context,
    Future<void> Function()? onCancel,
    Future<void> Function()? onConnectTimeout,
    Future<void> Function()? onReceiveTimeout,
    Future<void> Function()? onSendTimeout,
    Future<void> Function()? onResponseError,
    Future<void> Function()? onOtherError,
    Future<void> Function(StreamType result)? onSuccess,
    Future<void> Function()? onReSignIn,
    Widget Function(BuildContext context, StreamType value)? waitingBuilder,
    void Function(StreamType? value)? listener,
  }) => _runStream(
    requestStream: requestStream,
    context: context,
    onCancel: onCancel,
    onConnectTimeout: onConnectTimeout,
    onReceiveTimeout: onReceiveTimeout,
    onSendTimeout: onSendTimeout,
    onResponseError: onResponseError,
    onOtherError: onOtherError,
    onSuccess: onSuccess,
    onReSignIn: onReSignIn,
    showWaitingDialog: false,
    waitingBuilder: waitingBuilder,
    listener: listener,
  );
}
