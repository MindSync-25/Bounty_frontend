import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base contract for all Use Cases in the domain layer.
///
/// Each use case encapsulates exactly one business rule.
/// [Type]   → the successful return type.
/// [Params] → the input parameters.
///
/// Usage:
///   class GetNearbyBounties extends UseCase<List<BountyEntity>, NearbyParams> {
///     @override
///     Future<Either<Failure, List<BountyEntity>>> call(NearbyParams params) { ... }
///   }
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this for use cases that require no input parameters.
///
/// Usage:
///   class GetCurrentUser extends NoParamsUseCase<UserEntity> { ... }
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// Marker class for parameterless use case invocations.
class NoParams {
  const NoParams();
}
