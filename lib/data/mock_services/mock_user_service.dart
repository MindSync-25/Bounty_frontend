import 'package:uuid/uuid.dart';
import '../../core/config.dart';
import 'i_user_service.dart';
import 'mock_models/mock_user.dart';

/// [MockUserService] — Fake user/auth service for Phase 1.
class MockUserService implements IUserService {
  static const _uuid = Uuid();

  static final MockUser _currentUser = MockUser(
    id: 'mock-current-user',
    name: 'Ghost User',
    email: 'ghost@bountyghost.app',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    rating: 4.7,
    completedBounties: 23,
    postedBounties: 11,
    isVerified: true,
    joinedAt: DateTime(2025, 6, 15),
    bio: 'Hyper-local hustler. Always nearby. Always on time. 👻',
  );

  final List<MockUser> _users = [
    _currentUser,
    MockUser(
      id: 'user-002',
      name: 'Alex K.',
      email: 'alex@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
      rating: 4.9,
      completedBounties: 5,
      postedBounties: 8,
      isVerified: true,
      joinedAt: DateTime(2025, 8, 1),
    ),
    MockUser(
      id: 'user-003',
      name: 'Sam P.',
      email: 'sam@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      rating: 4.5,
      completedBounties: 12,
      postedBounties: 3,
      isVerified: false,
      joinedAt: DateTime(2025, 9, 10),
    ),
  ];

  @override
  Future<MockUser> getCurrentUser() async {
    await Future.delayed(AppConfig.mockLatency);
    return _currentUser;
  }

  @override
  Future<MockUser?> getUserById({required String userId}) async {
    await Future.delayed(AppConfig.mockLatency);
    try {
      return _users.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MockUser?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Accept any email matching mock user; password not validated in Phase 1
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MockUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newUser = MockUser(
      id: _uuid.v4(),
      name: name,
      email: email,
      avatarUrl: 'https://i.pravatar.cc/150?img=${DateTime.now().second}',
      rating: 0.0,
      completedBounties: 0,
      postedBounties: 0,
      isVerified: false,
      joinedAt: DateTime.now(),
    );
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(AppConfig.mockLatency);
    // Phase 2: Clear JWT from secure storage
  }
}
