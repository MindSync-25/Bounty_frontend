import 'package:equatable/equatable.dart';
import '../../../../data/mock_services/mock_models/mock_wallet.dart';

abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  const WalletLoaded({required this.wallet});
  final MockWallet wallet;
  @override
  List<Object?> get props => [wallet];
}

class WalletActionSuccess extends WalletState {
  const WalletActionSuccess({required this.wallet, required this.message});
  final MockWallet wallet;
  final String message;
  @override
  List<Object?> get props => [wallet, message];
}

class WalletError extends WalletState {
  const WalletError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
