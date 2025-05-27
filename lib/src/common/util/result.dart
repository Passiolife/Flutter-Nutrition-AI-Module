/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Success(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [data].
  const factory Result.success(T data) = Success._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;
}

/// Subclass of Result for values
final class Success<T> extends Result<T> {
  const Success._(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.success($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
