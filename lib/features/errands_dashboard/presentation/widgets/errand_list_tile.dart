import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/bounty_colors.dart';
import '../../../map_poster/domain/entities/bounty_entity.dart';

/// Errand list tile — shared between Posted and Hunting tabs.
class ErrandListTile extends StatelessWidget {
  const ErrandListTile({
    required this.bounty,
    required this.isPoster,
    super.key,
  });

  final BountyEntity bounty;
  final bool isPoster;

  Color get _statusColor {
    switch (bounty.statusLabel) {
      case 'open':
        return BountyColors.neonCyan;
      case 'accepted':
      case 'inProgress':
        return BountyColors.neonGreen;
      case 'completed':
        return BountyColors.textDisabled;
      case 'cancelled':
      case 'expired':
        return BountyColors.neonRed;
      default:
        return BountyColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BountyColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BountyColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 4,
            height: 56,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: _statusColor.withAlpha(80),
                  blurRadius: 6,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        bounty.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: BountyColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      bounty.rewardDisplay,
                      style: GoogleFonts.poppins(
                        color: BountyColors.neonCyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: _statusColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        bounty.statusLabel.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: _statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      bounty.categoryLabel,
                      style: GoogleFonts.poppins(
                        color: BountyColors.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: BountyColors.textDisabled,
            size: 18,
          ),
        ],
      ),
    );
  }
}
