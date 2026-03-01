import 'package:equatable/equatable.dart';

/// [MockTransaction] — Phase 1 mock model for a wallet transaction.
enum TransactionType { credit, debit, escrow, refund, withdrawal, deposit }

class MockTransaction extends Equatable {
  const MockTransaction({
    required this.id,
    required this.type,
    required this.amountCents,
    required this.description,
    required this.createdAt,
    this.bountyId,
    this.bountyTitle,
  });

  final String id;
  final TransactionType type;

  /// Amount in USD cents.
  final int amountCents;
  final String description;
  final DateTime createdAt;

  // Linked bounty (optional)
  final String? bountyId;
  final String? bountyTitle;

  bool get isCredit =>
      type == TransactionType.credit ||
      type == TransactionType.refund ||
      type == TransactionType.deposit;

  String get amountDisplay {
    final prefix = isCredit ? '+' : '-';
    return '$prefix\$${(amountCents / 100).toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [id, amountCents, type];
}

/// [MockWallet] — Phase 1 mock model for a user's wallet.
class MockWallet extends Equatable {
  const MockWallet({
    required this.userId,
    required this.balanceCents,
    required this.escrowCents,
    required this.transactions,
  });

  final String userId;

  /// Available balance in USD cents.
  final int balanceCents;

  /// Funds currently held in escrow for active bounties.
  final int escrowCents;

  final List<MockTransaction> transactions;

  int get totalCents => balanceCents + escrowCents;

  String get balanceDisplay =>
      '\$${(balanceCents / 100).toStringAsFixed(2)}';
  String get escrowDisplay =>
      '\$${(escrowCents / 100).toStringAsFixed(2)}';
  String get totalDisplay =>
      '\$${(totalCents / 100).toStringAsFixed(2)}';

  @override
  List<Object?> get props => [userId, balanceCents, escrowCents];
}
