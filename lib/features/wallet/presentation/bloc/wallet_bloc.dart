import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mock_services/i_wallet_service.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({required IWalletService walletService})
      : _service = walletService,
        super(const WalletInitial()) {
    on<LoadWallet>(_onLoad);
    on<DepositFunds>(_onDeposit);
    on<WithdrawFunds>(_onWithdraw);
  }

  final IWalletService _service;

  Future<void> _onLoad(LoadWallet event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());
    try {
      final wallet = await _service.getWallet(userId: event.userId);
      emit(WalletLoaded(wallet: wallet));
    } on Exception catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onDeposit(DepositFunds event, Emitter<WalletState> emit) async {
    try {
      final wallet = await _service.deposit(
        userId: event.userId,
        amountCents: event.amountCents,
      );
      emit(WalletActionSuccess(
        wallet: wallet,
        message: 'Successfully deposited \$${(event.amountCents / 100).toStringAsFixed(2)}',
      ));
      emit(WalletLoaded(wallet: wallet));
    } on Exception catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onWithdraw(
      WithdrawFunds event, Emitter<WalletState> emit) async {
    try {
      final wallet = await _service.withdraw(
        userId: event.userId,
        amountCents: event.amountCents,
      );
      emit(WalletActionSuccess(
        wallet: wallet,
        message: 'Withdrawal of \$${(event.amountCents / 100).toStringAsFixed(2)} initiated',
      ));
      emit(WalletLoaded(wallet: wallet));
    } on Exception catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }
}
