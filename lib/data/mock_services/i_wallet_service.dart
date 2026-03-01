import 'mock_models/mock_wallet.dart';

/// [IWalletService] — Interface contract for wallet operations.
///
/// Phase 1: [MockWalletService]. Phase 2: RemoteWalletService → Spring Boot.
abstract class IWalletService {
  /// Fetch the wallet for a given user.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/wallet/{userId}
  Future<MockWallet> getWallet({required String userId});

  /// Add funds to wallet (deposit).
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/wallet/deposit
  Future<MockWallet> deposit({
    required String userId,
    required int amountCents,
  });

  /// Withdraw available balance.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   POST /api/v1/wallet/withdraw
  Future<MockWallet> withdraw({
    required String userId,
    required int amountCents,
  });

  /// Get paginated transaction history.
  ///
  /// Spring Boot endpoint (Phase 2):
  ///   GET /api/v1/wallet/{userId}/transactions?page=&size=
  Future<List<MockTransaction>> getTransactions({
    required String userId,
    int page = 0,
    int size = 20,
  });
}
