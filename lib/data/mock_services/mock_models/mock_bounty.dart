import 'package:equatable/equatable.dart';

/// [MockBounty] — Phase 1 mock model representing a posted bounty.
///
/// Phase 2 → Replace with [BountyEntity] from domain layer, mapped from
/// Spring Boot's BountyDTO JSON response.
enum BountyStatus { open, accepted, inProgress, completed, cancelled, expired }

enum BountyCategory {
  delivery,
  errand,
  tech,
  creative,
  manual,
  social,
  other,
}

extension BountyCategoryLabel on BountyCategory {
  String get label {
    switch (this) {
      case BountyCategory.delivery:
        return 'Delivery';
      case BountyCategory.errand:
        return 'Errand';
      case BountyCategory.tech:
        return 'Tech Help';
      case BountyCategory.creative:
        return 'Creative';
      case BountyCategory.manual:
        return 'Manual';
      case BountyCategory.social:
        return 'Social';
      case BountyCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case BountyCategory.delivery:
        return '📦';
      case BountyCategory.errand:
        return '🛒';
      case BountyCategory.tech:
        return '💻';
      case BountyCategory.creative:
        return '🎨';
      case BountyCategory.manual:
        return '🔧';
      case BountyCategory.social:
        return '👋';
      case BountyCategory.other:
        return '🎯';
    }
  }
}

class MockBounty extends Equatable {
  const MockBounty({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.lat,
    required this.lng,
    required this.status,
    required this.category,
    required this.posterId,
    required this.posterName,
    required this.posterAvatarUrl,
    required this.postedAt,
    required this.expiresAt,
    required this.distanceKm,
    this.hunterId,
    this.hunterName,
    this.isUrgent = false,
  });

  final String id;
  final String title;
  final String description;

  /// Reward amount in USD cents to avoid floating-point issues.
  final int reward;

  final double lat;
  final double lng;
  final BountyStatus status;
  final BountyCategory category;

  // Poster info
  final String posterId;
  final String posterName;
  final String posterAvatarUrl;

  // Hunter info (nullable until accepted)
  final String? hunterId;
  final String? hunterName;

  final DateTime postedAt;
  final DateTime expiresAt;

  /// Pre-computed straight-line distance from the requesting user's location.
  final double distanceKm;

  /// Whether the bounty is flagged as urgent (neon red highlight).
  final bool isUrgent;

  // ── Derived ───────────────────────────────────────────────────────────────

  /// Reward formatted as a USD string: "$12.50"
  String get rewardDisplay =>
      '\$${(reward / 100).toStringAsFixed(2)}';

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isOpen => status == BountyStatus.open;

  Duration get timeRemaining => expiresAt.difference(DateTime.now());

  String get distanceDisplay => distanceKm < 1
      ? '${(distanceKm * 1000).toStringAsFixed(0)}m away'
      : '${distanceKm.toStringAsFixed(1)}km away';

  MockBounty copyWith({
    String? id,
    String? title,
    String? description,
    int? reward,
    double? lat,
    double? lng,
    BountyStatus? status,
    BountyCategory? category,
    String? posterId,
    String? posterName,
    String? posterAvatarUrl,
    String? hunterId,
    String? hunterName,
    DateTime? postedAt,
    DateTime? expiresAt,
    double? distanceKm,
    bool? isUrgent,
  }) {
    return MockBounty(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      category: category ?? this.category,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      posterAvatarUrl: posterAvatarUrl ?? this.posterAvatarUrl,
      hunterId: hunterId ?? this.hunterId,
      hunterName: hunterName ?? this.hunterName,
      postedAt: postedAt ?? this.postedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      distanceKm: distanceKm ?? this.distanceKm,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }

  @override
  List<Object?> get props => [id, status, reward, hunterId];
}
