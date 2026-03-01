import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
///
/// Use with [dartz]'s Either:
///   Future<Either<Failure, T>> someUseCase()
///
/// Pattern: UI receives a [Failure] subclass and maps it to a user-facing message
/// without leaking internal error details.
abstract class Failure extends Equatable {
  const Failure({required this.message, this.code});

  /// Human-readable message safe to surface in the UI.
  final String message;

  /// Optional machine-readable code (e.g., HTTP status or Spring error code).
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

// ─── Concrete Failures ───────────────────────────────────────────────────────

/// Fired when a server returns a non-2xx response.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Fired when the device has no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

/// Fired when local cache / storage operations fail.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Fired when user input fails domain-level validation.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Fired when the user is not authenticated.
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication required.'});
}

/// Fired when a requested resource does not exist (HTTP 404).
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code = '404'});
}

/// Fired when the mock service encounters an unexpected error.
class MockFailure extends Failure {
  const MockFailure({required super.message});
}
