import 'package:equatable/equatable.dart';

/// [MockUser] — Phase 1 mock model for an app user.
class MockUser extends Equatable {
  const MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.rating,
    required this.completedBounties,
    required this.postedBounties,
    required this.isVerified,
    required this.joinedAt,
    this.bio,
  });

  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  /// Rating out of 5.0
  final double rating;
  final int completedBounties;
  final int postedBounties;
  final bool isVerified;
  final DateTime joinedAt;
  final String? bio;

  String get ratingDisplay => rating.toStringAsFixed(1);

  @override
  List<Object?> get props => [id, email];
}
