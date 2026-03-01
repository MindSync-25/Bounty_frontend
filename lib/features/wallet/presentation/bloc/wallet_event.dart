import 'package:equatable/equatable.dart';
import '../../../../data/mock_services/mock_models/mock_wallet.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {
  const LoadWallet({required this.userId});
  final String userId;
  @override
  List<Object?> get props => [userId];
}

class DepositFunds extends WalletEvent {
  const DepositFunds({required this.userId, required this.amountCents});
  final String userId;
  final int amountCents;
  @override
  List<Object?> get props => [userId, amountCents];
}

class WithdrawFunds extends WalletEvent {
  const WithdrawFunds({required this.userId, required this.amountCents});
  final String userId;
  final int amountCents;
  @override
  List<Object?> get props => [userId, amountCents];
}
