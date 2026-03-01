import 'mock_models/mock_user.dart';

/// [IUserService] — Interface contract for user / auth operations.
///
/// Phase 1: [MockUserService]. Phase 2: RemoteUserService → Spring Boot.
abstract class IUserService {
  /// Returns the currently "logged in" mock user.
  Future<MockUser> getCurrentUser();

  /// Lookup a user profile by ID.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/users/{id}
  Future<MockUser?> getUserById({required String userId});

  /// Simulates login — returns a user if credentials match mock data.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/auth/login  → returns JWT
  Future<MockUser?> login({
    required String email,
    required String password,
  });

  /// Simulates registration.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/auth/register
  Future<MockUser> register({
    required String name,
    required String email,
    required String password,
  });

  /// Simulates logout (clears session token in Phase 2).
  Future<void> logout();
}
