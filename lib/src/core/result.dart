/// Result types for SmartExecuter operations.
///
/// This library provides a Result pattern for handling success and failure
/// cases in a type-safe manner.
library;

import 'package:smart_executer/src/core/exceptions.dart';

/// Represents the result of an operation that can either succeed or fail.
///
/// Use pattern matching to handle both cases:
/// ```dart
/// final result = await SmartExecuter.execute(() => fetchData());
///
/// switch (result) {
///   case Success(:final data):
///     print('Got data: $data');
///   case Failure(:final exception):
///     print('Error: ${exception.message}');
/// }
/// ```
sealed class Result<T> {
  const Result._();

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Returns the data if this is a [Success], otherwise returns null.
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// Returns the exception if this is a [Failure], otherwise returns null.
  SmartException? get exceptionOrNull => switch (this) {
        Success() => null,
        Failure(:final exception) => exception,
      };

  /// Returns the data if this is a [Success], otherwise throws the exception.
  T get dataOrThrow => switch (this) {
        Success(:final data) => data,
        Failure(:final exception) => throw exception,
      };

  /// Transforms the data if this is a [Success].
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success(:final data) => Success(transform(data)),
        Failure(:final exception) => Failure(exception),
      };

  /// Transforms the data if this is a [Success], allowing for another Result.
  Result<R> flatMap<R>(Result<R> Function(T data) transform) => switch (this) {
        Success(:final data) => transform(data),
        Failure(:final exception) => Failure(exception),
      };

  /// Executes [onSuccess] if this is a [Success], otherwise [onFailure].
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(SmartException exception) onFailure,
  }) =>
      switch (this) {
        Success(:final data) => onSuccess(data),
        Failure(:final exception) => onFailure(exception),
      };

  /// Executes [action] if this is a [Success].
  Result<T> onSuccess(void Function(T data) action) {
    if (this case Success(:final data)) {
      action(data);
    }
    return this;
  }

  /// Executes [action] if this is a [Failure].
  Result<T> onFailure(void Function(SmartException exception) action) {
    if (this case Failure(:final exception)) {
      action(exception);
    }
    return this;
  }

  /// Returns the data if this is a [Success], otherwise returns [defaultValue].
  T getOrElse(T defaultValue) => switch (this) {
        Success(:final data) => data,
        Failure() => defaultValue,
      };

  /// Returns the data if this is a [Success], otherwise computes a default.
  T getOrCompute(T Function() compute) => switch (this) {
        Success(:final data) => data,
        Failure() => compute(),
      };
}

/// Represents a successful result containing [data].
final class Success<T> extends Result<T> {
  /// Creates a successful result with the given [data].
  const Success(this.data) : super._();

  /// The data returned by the operation.
  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result containing an [exception].
final class Failure<T> extends Result<T> {
  /// Creates a failed result with the given [exception].
  const Failure(this.exception) : super._();

  /// The exception that caused the failure.
  final SmartException exception;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && runtimeType == other.runtimeType && exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Failure($exception)';
}

/// Extension methods for creating Results.
extension ResultExtensions<T> on T {
  /// Wraps this value in a [Success].
  Result<T> toSuccess() => Success(this);
}

/// Extension methods for creating Failures from exceptions.
extension SmartExceptionExtensions on SmartException {
  /// Wraps this exception in a [Failure].
  Failure<T> toFailure<T>() => Failure<T>(this);
}
