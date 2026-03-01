import 'package:equatable/equatable.dart';

abstract class ErrandsEvent extends Equatable {
  const ErrandsEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyErrands extends ErrandsEvent {
  const LoadMyErrands({required this.userId});
  final String userId;
  @override
  List<Object?> get props => [userId];
}

class RefreshErrands extends ErrandsEvent {
  const RefreshErrands({required this.userId});
  final String userId;
  @override
  List<Object?> get props => [userId];
}
