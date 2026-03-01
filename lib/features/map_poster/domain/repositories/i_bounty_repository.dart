import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bounty_entity.dart';

/// [IBountyRepository] — Domain-layer gateway for bounty operations.
///
/// Phase 1: Implemented by [BountyRepositoryImpl] which delegates to [MockBountyService].
/// Phase 2: [BountyRepositoryImpl] delegates to [RemoteBountyService] (Dio).
abstract class IBountyRepository {
  Future<Either<Failure, List<BountyEntity>>> getNearbyBounties({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  });

  Future<Either<Failure, BountyEntity>> postBounty({
    required String title,
    required String description,
    required int rewardCents,
    required String category,
    required double lat,
    required double lng,
    required Duration expiresIn,
    bool isUrgent = false,
  });

  Future<Either<Failure, BountyEntity>> acceptBounty({
    required String bountyId,
    required String hunterId,
  });

  Future<Either<Failure, BountyEntity>> completeBounty({
    required String bountyId,
  });

  Future<Either<Failure, BountyEntity>> cancelBounty({
    required String bountyId,
  });

  Future<Either<Failure, List<BountyEntity>>> getMyPostedBounties({
    required String userId,
  });

  Future<Either<Failure, List<BountyEntity>>> getMyAcceptedBounties({
    required String userId,
  });
}
