import 'package:equatable/equatable.dart';

abstract class MapPosterEvent extends Equatable {
  const MapPosterEvent();

  @override
  List<Object?> get props => [];
}

/// Load bounties near the given coordinates.
class LoadNearbyBounties extends MapPosterEvent {
  const LoadNearbyBounties({
    required this.lat,
    required this.lng,
    this.radiusKm = 5.0,
  });

  final double lat;
  final double lng;
  final double radiusKm;

  @override
  List<Object?> get props => [lat, lng, radiusKm];
}

/// User taps the "Post Bounty" FAB to open the sheet.
class OpenPostBountySheet extends MapPosterEvent {
  const OpenPostBountySheet();
}

/// User submits a new bounty from the post-bounty sheet.
class SubmitNewBounty extends MapPosterEvent {
  const SubmitNewBounty({
    required this.title,
    required this.description,
    required this.rewardCents,
    required this.category,
    required this.lat,
    required this.lng,
    required this.expiresIn,
    this.isUrgent = false,
  });

  final String title;
  final String description;
  final int rewardCents;
  final String category;
  final double lat;
  final double lng;
  final Duration expiresIn;
  final bool isUrgent;

  @override
  List<Object?> get props => [title, rewardCents, category, lat, lng];
}

/// User taps a bounty marker on the map.
class SelectBounty extends MapPosterEvent {
  const SelectBounty({required this.bountyId});
  final String bountyId;

  @override
  List<Object?> get props => [bountyId];
}

/// User dismisses selected bounty panel.
class DeselectBounty extends MapPosterEvent {
  const DeselectBounty();
}

/// Cancel a posted bounty.
class CancelBounty extends MapPosterEvent {
  const CancelBounty({required this.bountyId});
  final String bountyId;

  @override
  List<Object?> get props => [bountyId];
}

/// Toggle between Poster mode and Hunter mode on the map.
class ToggleHunterMode extends MapPosterEvent {
  const ToggleHunterMode();
}
