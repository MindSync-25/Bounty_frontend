import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/bounty_colors.dart';
import '../../../../data/mock_services/mock_models/mock_wallet.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, super.key});
  final MockTransaction transaction;

  Color get _amountColor =>
      transaction.isCredit ? BountyColors.neonGreen : BountyColors.neonRed;

  IconData get _typeIcon {
    switch (transaction.type) {
      case TransactionType.credit:
        return Icons.arrow_downward;
      case TransactionType.debit:
        return Icons.arrow_upward;
      case TransactionType.escrow:
        return Icons.lock_outline;
      case TransactionType.refund:
        return Icons.undo;
      case TransactionType.withdrawal:
        return Icons.account_balance_outlined;
      case TransactionType.deposit:
        return Icons.add_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BountyColors.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: const Border.fromBorderSide(
          BorderSide(color: BountyColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _amountColor.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_typeIcon, color: _amountColor, size: 18),
          ),

          const SizedBox(width: 12),

          // Description + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: GoogleFonts.poppins(
                    color: BountyColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormat('MMM d · h:mm a').format(transaction.createdAt),
                  style: GoogleFonts.poppins(
                    color: BountyColors.textDisabled,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            transaction.amountDisplay,
            style: GoogleFonts.poppins(
              color: _amountColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
