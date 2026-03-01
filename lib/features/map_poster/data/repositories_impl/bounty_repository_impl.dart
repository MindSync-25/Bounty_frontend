import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../data/mock_services/i_bounty_service.dart';
import '../../../../data/mock_services/mock_models/mock_bounty.dart';
import '../../domain/entities/bounty_entity.dart';
import '../../domain/repositories/i_bounty_repository.dart';

/// [BountyRepositoryImpl] — Bridges domain layer with the data service.
///
/// Phase 1: [IBountyService] resolves to [MockBountyService].
/// Phase 2: [IBountyService] resolves to [RemoteBountyService].
/// The BLoC calls THIS class and is unaware of which impl is injected.
class BountyRepositoryImpl implements IBountyRepository {
  const BountyRepositoryImpl({required this.service});

  final IBountyService service;

  @override
  Future<Either<Failure, List<BountyEntity>>> getNearbyBounties({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    try {
      final bounties = await service.fetchNearbyBounties(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
      );
      return Right(bounties.map(_toEntity).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BountyEntity>> postBounty({
    required String title,
    required String description,
    required int rewardCents,
    required String category,
    required double lat,
    required double lng,
    required Duration expiresIn,
    bool isUrgent = false,
  }) async {
    try {
      final bounty = await service.postBounty(
        title: title,
        description: description,
        rewardCents: rewardCents,
        category: _categoryFromString(category),
        lat: lat,
        lng: lng,
        expiresIn: expiresIn,
        isUrgent: isUrgent,
      );
      return Right(_toEntity(bounty));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BountyEntity>> acceptBounty({
    required String bountyId,
    required String hunterId,
  }) async {
    try {
      final b = await service.acceptBounty(
        bountyId: bountyId,
        hunterId: hunterId,
      );
      return Right(_toEntity(b));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BountyEntity>> completeBounty({
    required String bountyId,
  }) async {
    try {
      final b = await service.completeBounty(bountyId: bountyId);
      return Right(_toEntity(b));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BountyEntity>> cancelBounty({
    required String bountyId,
  }) async {
    try {
      final b = await service.cancelBounty(bountyId: bountyId);
      return Right(_toEntity(b));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BountyEntity>>> getMyPostedBounties({
    required String userId,
  }) async {
    try {
      final list = await service.fetchMyPostedBounties(userId: userId);
      return Right(list.map(_toEntity).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BountyEntity>>> getMyAcceptedBounties({
    required String userId,
  }) async {
    try {
      final list = await service.fetchMyAcceptedBounties(userId: userId);
      return Right(list.map(_toEntity).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Mappers ────────────────────────────────────────────────────────────────

  /// Public mapper — reusable by other features' repository impls.
  static BountyEntity toEntityPublic(MockBounty b) => _toEntity(b);

  static BountyEntity _toEntity(MockBounty b) => BountyEntity(
        id: b.id,
        title: b.title,
        description: b.description,
        rewardCents: b.reward,
        lat: b.lat,
        lng: b.lng,
        statusLabel: b.status.name,
        categoryLabel: b.category.label,
        posterId: b.posterId,
        posterName: b.posterName,
        hunterId: b.hunterId,
        postedAt: b.postedAt,
        expiresAt: b.expiresAt,
        distanceKm: b.distanceKm,
        isUrgent: b.isUrgent,
      );

  static BountyCategory _categoryFromString(String s) {
    return BountyCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == s.toLowerCase(),
      orElse: () => BountyCategory.other,
    );
  }
}
