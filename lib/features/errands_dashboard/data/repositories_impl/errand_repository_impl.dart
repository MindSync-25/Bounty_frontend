import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../data/mock_services/i_bounty_service.dart';
import '../../../../data/mock_services/mock_models/mock_bounty.dart';
import '../../../map_poster/data/repositories_impl/bounty_repository_impl.dart';
import '../../../map_poster/domain/entities/bounty_entity.dart';

/// [ErrandRepositoryImpl] — Reuses [BountyRepositoryImpl] logic for
/// the errand-specific queries (posted + accepted by current user).
class ErrandRepositoryImpl {
  const ErrandRepositoryImpl({required this.service});
  final IBountyService service;

  Future<Either<Failure, List<BountyEntity>>> getPostedBounties({
    required String userId,
  }) async {
    try {
      final list = await service.fetchMyPostedBounties(userId: userId);
      return Right(list.map(BountyRepositoryImpl.toEntityPublic).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<BountyEntity>>> getAcceptedBounties({
    required String userId,
  }) async {
    try {
      final list = await service.fetchMyAcceptedBounties(userId: userId);
      return Right(list.map(BountyRepositoryImpl.toEntityPublic).toList());
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
