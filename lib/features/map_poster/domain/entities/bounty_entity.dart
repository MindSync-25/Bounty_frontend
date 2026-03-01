import 'package:equatable/equatable.dart';

/// [BountyEntity] — Pure domain model. No JSON, no Flutter dependencies.
///
/// Lives in the domain layer. Has no knowledge of MockBounty or DTOs.
/// Phase 2: Mapped from BountyModel (data layer) via a mapper/extension.
class BountyEntity extends Equatable {
  const BountyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardCents,
    required this.lat,
    required this.lng,
    required this.statusLabel,
    required this.categoryLabel,
    required this.posterId,
    required this.posterName,
    required this.postedAt,
    required this.expiresAt,
    required this.distanceKm,
    this.isUrgent = false,
    this.hunterId,
  });

  final String id;
  final String title;
  final String description;
  final int rewardCents;
  final double lat;
  final double lng;
  final String statusLabel;
  final String categoryLabel;
  final String posterId;
  final String posterName;
  final String? hunterId;
  final DateTime postedAt;
  final DateTime expiresAt;
  final double distanceKm;
  final bool isUrgent;

  String get rewardDisplay =>
      '\$${(rewardCents / 100).toStringAsFixed(2)}';

  @override
  List<Object?> get props => [id, rewardCents, statusLabel];
}
