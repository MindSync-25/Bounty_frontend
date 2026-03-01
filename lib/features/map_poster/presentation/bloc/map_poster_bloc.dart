import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_bounty_repository.dart';
import 'map_poster_event.dart';
import 'map_poster_state.dart';

/// [MapPosterBloc] — Orchestrates all state for the Unified Map screen.
///
/// Handles: loading nearby bounties, selecting a bounty marker,
/// opening the post sheet, and submitting a new bounty.
class MapPosterBloc extends Bloc<MapPosterEvent, MapPosterState> {
  MapPosterBloc({required IBountyRepository repository})
      : _repository = repository,
        super(const MapPosterInitial()) {
    on<LoadNearbyBounties>(_onLoadNearby);
    on<OpenPostBountySheet>(_onOpenSheet);
    on<SubmitNewBounty>(_onSubmitBounty);
    on<SelectBounty>(_onSelectBounty);
    on<DeselectBounty>(_onDeselect);
    on<CancelBounty>(_onCancelBounty);
    on<ToggleHunterMode>(_onToggleHunterMode);
  }

  final IBountyRepository _repository;

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onLoadNearby(
    LoadNearbyBounties event,
    Emitter<MapPosterState> emit,
  ) async {
    emit(const MapPosterLoading());
    final result = await _repository.getNearbyBounties(
      lat: event.lat,
      lng: event.lng,
      radiusKm: event.radiusKm,
    );
    result.fold(
      (failure) => emit(MapPosterError(message: failure.message)),
      (bounties) => emit(MapPosterLoaded(bounties: bounties)),
    );
  }

  void _onOpenSheet(
    OpenPostBountySheet event,
    Emitter<MapPosterState> emit,
  ) {
    final current = state;
    if (current is MapPosterLoaded) {
      emit(current.copyWith(isPostSheetOpen: true));
    }
  }

  Future<void> _onSubmitBounty(
    SubmitNewBounty event,
    Emitter<MapPosterState> emit,
  ) async {
    final current = state;
    if (current is! MapPosterLoaded) return;

    emit(current.copyWith(isSubmitting: true, isPostSheetOpen: false));

    final result = await _repository.postBounty(
      title: event.title,
      description: event.description,
      rewardCents: event.rewardCents,
      category: event.category,
      lat: event.lat,
      lng: event.lng,
      expiresIn: event.expiresIn,
      isUrgent: event.isUrgent,
    );

    result.fold(
      (failure) => emit(MapPosterError(message: failure.message)),
      (bounty) {
        final updated = [...current.bounties, bounty];
        emit(BountyPostedSuccess(bounty: bounty, bounties: updated));
        // Immediately transition back to loaded so the map refreshes
        emit(MapPosterLoaded(bounties: updated));
      },
    );
  }

  void _onSelectBounty(
    SelectBounty event,
    Emitter<MapPosterState> emit,
  ) {
    final current = state;
    if (current is! MapPosterLoaded) return;
    try {
      final bounty = current.bounties.firstWhere((b) => b.id == event.bountyId);
      emit(current.copyWith(selectedBounty: bounty));
    } catch (_) {
      // Bounty not in current list — ignore
    }
  }

  void _onDeselect(DeselectBounty event, Emitter<MapPosterState> emit) {
    final current = state;
    if (current is MapPosterLoaded) {
      emit(current.copyWith(clearSelection: true));
    }
  }

  Future<void> _onCancelBounty(
    CancelBounty event,
    Emitter<MapPosterState> emit,
  ) async {
    final current = state;
    if (current is! MapPosterLoaded) return;

    final result = await _repository.cancelBounty(bountyId: event.bountyId);
    result.fold(
      (failure) => emit(MapPosterError(message: failure.message)),
      (updated) {
        final bounties = current.bounties
            .map((b) => b.id == updated.id ? updated : b)
            .toList();
        emit(MapPosterLoaded(bounties: bounties));
      },
    );
  }

  void _onToggleHunterMode(
    ToggleHunterMode event,
    Emitter<MapPosterState> emit,
  ) {
    final current = state;
    if (current is! MapPosterLoaded) return;
    emit(current.copyWith(
      isHunterMode: !current.isHunterMode,
      clearSelection: true,
      isPostSheetOpen: false,
    ));
  }
}
