import 'package:equatable/equatable.dart';
import '../../domain/entities/bounty_entity.dart';

abstract class MapPosterState extends Equatable {
  const MapPosterState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no data loaded.
class MapPosterInitial extends MapPosterState {
  const MapPosterInitial();
}

/// Loading nearby bounties from service.
class MapPosterLoading extends MapPosterState {
  const MapPosterLoading();
}

/// Nearby bounties loaded and visible on map.
class MapPosterLoaded extends MapPosterState {
  const MapPosterLoaded({
    required this.bounties,
    this.selectedBounty,
    this.isPostSheetOpen = false,
    this.isSubmitting = false,
    this.isHunterMode = false,
  });

  final List<BountyEntity> bounties;
  final BountyEntity? selectedBounty;
  final bool isPostSheetOpen;
  final bool isSubmitting;
  final bool isHunterMode;

  MapPosterLoaded copyWith({
    List<BountyEntity>? bounties,
    BountyEntity? selectedBounty,
    bool clearSelection = false,
    bool? isPostSheetOpen,
    bool? isSubmitting,
    bool? isHunterMode,
  }) {
    return MapPosterLoaded(
      bounties: bounties ?? this.bounties,
      selectedBounty: clearSelection ? null : (selectedBounty ?? this.selectedBounty),
      isPostSheetOpen: isPostSheetOpen ?? this.isPostSheetOpen,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isHunterMode: isHunterMode ?? this.isHunterMode,
    );
  }

  @override
  List<Object?> get props => [
        bounties,
        selectedBounty,
        isPostSheetOpen,
        isSubmitting,
        isHunterMode,
      ];
}

/// A new bounty was successfully posted.
class BountyPostedSuccess extends MapPosterState {
  const BountyPostedSuccess({required this.bounty, required this.bounties});

  final BountyEntity bounty;
  final List<BountyEntity> bounties;

  @override
  List<Object?> get props => [bounty];
}

/// An error occurred.
class MapPosterError extends MapPosterState {
  const MapPosterError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
