import 'package:uuid/uuid.dart';
import '../../core/config.dart';
import 'i_wallet_service.dart';
import 'mock_models/mock_wallet.dart';

/// [MockWalletService] — Fake wallet service for Phase 1.
class MockWalletService implements IWalletService {
  static const _uuid = Uuid();

  // In-memory wallets keyed by userId
  final Map<String, MockWallet> _wallets = {
    'mock-current-user': MockWallet(
      userId: 'mock-current-user',
      balanceCents: 12750, // \$127.50
      escrowCents: 5000,   // \$50.00 in escrow (active bounty)
      transactions: _seedTransactions(),
    ),
  };

  @override
  Future<MockWallet> getWallet({required String userId}) async {
    await Future.delayed(AppConfig.mockLatency);
    return _wallets.putIfAbsent(
      userId,
      () => MockWallet(
        userId: userId,
        balanceCents: 0,
        escrowCents: 0,
        transactions: [],
      ),
    );
  }

  @override
  Future<MockWallet> deposit({
    required String userId,
    required int amountCents,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final wallet = await getWallet(userId: userId);
    final tx = MockTransaction(
      id: _uuid.v4(),
      type: TransactionType.deposit,
      amountCents: amountCents,
      description: 'Wallet top-up',
      createdAt: DateTime.now(),
    );
    final updated = MockWallet(
      userId: userId,
      balanceCents: wallet.balanceCents + amountCents,
      escrowCents: wallet.escrowCents,
      transactions: [tx, ...wallet.transactions],
    );
    _wallets[userId] = updated;
    return updated;
  }

  @override
  Future<MockWallet> withdraw({
    required String userId,
    required int amountCents,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final wallet = await getWallet(userId: userId);
    if (amountCents > wallet.balanceCents) {
      throw Exception('Insufficient balance');
    }
    final tx = MockTransaction(
      id: _uuid.v4(),
      type: TransactionType.withdrawal,
      amountCents: amountCents,
      description: 'Withdrawal to bank',
      createdAt: DateTime.now(),
    );
    final updated = MockWallet(
      userId: userId,
      balanceCents: wallet.balanceCents - amountCents,
      escrowCents: wallet.escrowCents,
      transactions: [tx, ...wallet.transactions],
    );
    _wallets[userId] = updated;
    return updated;
  }

  @override
  Future<List<MockTransaction>> getTransactions({
    required String userId,
    int page = 0,
    int size = 20,
  }) async {
    await Future.delayed(AppConfig.mockLatency);
    final wallet = await getWallet(userId: userId);
    final start = page * size;
    final end = (start + size).clamp(0, wallet.transactions.length);
    if (start >= wallet.transactions.length) return [];
    return wallet.transactions.sublist(start, end);
  }

  static List<MockTransaction> _seedTransactions() {
    final now = DateTime.now();
    return [
      MockTransaction(
        id: 'tx-001',
        type: TransactionType.credit,
        amountCents: 3500,
        description: 'Bounty completed: WiFi setup',
        createdAt: now.subtract(const Duration(hours: 2)),
        bountyId: 'bounty-002',
        bountyTitle: 'Tech support — WiFi setup',
      ),
      MockTransaction(
        id: 'tx-002',
        type: TransactionType.escrow,
        amountCents: 5000,
        description: 'Escrow held: Urgent pharmacy run',
        createdAt: now.subtract(const Duration(hours: 5)),
        bountyId: 'bounty-003',
        bountyTitle: 'URGENT: Pharmacy run',
      ),
      MockTransaction(
        id: 'tx-003',
        type: TransactionType.deposit,
        amountCents: 10000,
        description: 'Wallet top-up via Apple Pay',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      MockTransaction(
        id: 'tx-004',
        type: TransactionType.credit,
        amountCents: 1200,
        description: 'Bounty completed: Dry cleaning pickup',
        createdAt: now.subtract(const Duration(days: 2)),
        bountyId: 'bounty-001',
        bountyTitle: 'Pick up my dry cleaning',
      ),
      MockTransaction(
        id: 'tx-005',
        type: TransactionType.debit,
        amountCents: 2500,
        description: 'Bounty posted: Move boxes to storage',
        createdAt: now.subtract(const Duration(days: 3)),
        bountyId: 'bounty-005',
        bountyTitle: 'Move 4 boxes to storage unit',
      ),
    ];
  }
}
