import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories_impl/errand_repository_impl.dart';
import 'errands_event.dart';
import 'errands_state.dart';

class ErrandsBloc extends Bloc<ErrandsEvent, ErrandsState> {
  ErrandsBloc({required ErrandRepositoryImpl repository})
      : _repository = repository,
        super(const ErrandsInitial()) {
    on<LoadMyErrands>(_onLoad);
    on<RefreshErrands>(_onRefresh);
  }

  final ErrandRepositoryImpl _repository;

  Future<void> _onLoad(
    LoadMyErrands event,
    Emitter<ErrandsState> emit,
  ) async {
    emit(const ErrandsLoading());
    await _fetch(event.userId, emit);
  }

  Future<void> _onRefresh(
    RefreshErrands event,
    Emitter<ErrandsState> emit,
  ) async {
    await _fetch(event.userId, emit);
  }

  Future<void> _fetch(String userId, Emitter<ErrandsState> emit) async {
    final posted = await _repository.getPostedBounties(userId: userId);
    final accepted = await _repository.getAcceptedBounties(userId: userId);

    final postedList = posted.getOrElse(() => []);
    final acceptedList = accepted.getOrElse(() => []);

    Failure? error;
    posted.fold((f) => error = f, (_) {});
    if (error != null) {
      emit(ErrandsError(message: error!.message));
      return;
    }

    emit(ErrandsLoaded(
      postedBounties: postedList,
      acceptedBounties: acceptedList,
    ));
  }
}
