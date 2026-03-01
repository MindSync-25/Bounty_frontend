import 'mock_models/mock_bounty.dart';

/// [IBountyService] — Interface contract for all bounty operations.
///
/// Phase 1: Implemented by [MockBountyService] (in-memory, fake data).
/// Phase 2: Implemented by [RemoteBountyService] (Dio → Spring Boot REST).
///
/// The BLoC and domain layers only ever reference this interface, ensuring
/// the swap in Phase 2 requires zero UI changes.
abstract class IBountyService {
  /// Fetch bounties near [lat]/[lng] within [radiusKm].
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/bounties/nearby?lat=&lng=&radiusKm=
  Future<List<MockBounty>> fetchNearbyBounties({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  });

  /// Post a new bounty from the current user.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/bounties
  Future<MockBounty> postBounty({
    required String title,
    required String description,
    required int rewardCents,
    required BountyCategory category,
    required double lat,
    required double lng,
    required Duration expiresIn,
    bool isUrgent = false,
  });

  /// Accept an open bounty as a hunter.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/bounties/{id}/accept
  Future<MockBounty> acceptBounty({
    required String bountyId,
    required String hunterId,
  });

  /// Mark a bounty as completed (poster confirms delivery).
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/bounties/{id}/complete
  Future<MockBounty> completeBounty({required String bountyId});

  /// Cancel a bounty (only poster, while still open).
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   DELETE /api/v1/bounties/{id}
  Future<MockBounty> cancelBounty({required String bountyId});

  /// Get all bounties posted by [userId].
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/bounties?posterId=
  Future<List<MockBounty>> fetchMyPostedBounties({required String userId});

  /// Get all bounties accepted/hunted by [userId].
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/bounties?hunterId=
  Future<List<MockBounty>> fetchMyAcceptedBounties({required String userId});

  /// Get a single bounty by ID.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/bounties/{id}
  Future<MockBounty?> fetchBountyById({required String bountyId});
}
