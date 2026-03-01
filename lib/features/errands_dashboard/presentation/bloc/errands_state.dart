import 'package:equatable/equatable.dart';
import '../../../map_poster/domain/entities/bounty_entity.dart';

abstract class ErrandsState extends Equatable {
  const ErrandsState();
  @override
  List<Object?> get props => [];
}

class ErrandsInitial extends ErrandsState {
  const ErrandsInitial();
}

class ErrandsLoading extends ErrandsState {
  const ErrandsLoading();
}

class ErrandsLoaded extends ErrandsState {
  const ErrandsLoaded({
    required this.postedBounties,
    required this.acceptedBounties,
  });

  final List<BountyEntity> postedBounties;
  final List<BountyEntity> acceptedBounties;

  @override
  List<Object?> get props => [postedBounties, acceptedBounties];
}

class ErrandsError extends ErrandsState {
  const ErrandsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
