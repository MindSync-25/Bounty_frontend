import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/bounty_colors.dart';
import '../../domain/entities/bounty_entity.dart';

/// Compact horizontal-scroll card for the "nearby bounties" strip.
class NearbyBountyCard extends StatelessWidget {
  const NearbyBountyCard({
    required this.bounty,
    required this.onTap,
    super.key,
  });

  final BountyEntity bounty;
  final VoidCallback onTap;

  Color get _accent =>
      bounty.isUrgent ? BountyColors.neonRed : BountyColors.neonCyan;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BountyColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _accent.withAlpha(120), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chip + reward
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: BountyColors.backgroundLayer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    bounty.categoryLabel,
                    style: GoogleFonts.poppins(
                      color: BountyColors.textDisabled,
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  bounty.rewardDisplay,
                  style: GoogleFonts.poppins(
                    color: _accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Title
            Text(
              bounty.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: BountyColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),

            const Spacer(),

            // Distance
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 10,
                  color: BountyColors.textDisabled,
                ),
                const SizedBox(width: 2),
                Text(
                  '${bounty.distanceKm.toStringAsFixed(1)} km',
                  style: GoogleFonts.poppins(
                    color: BountyColors.textDisabled,
                    fontSize: 10,
                  ),
                ),
                if (bounty.isUrgent) ...[
                  const SizedBox(width: 6),
                  Text(
                    '🚨 URGENT',
                    style: GoogleFonts.poppins(
                      color: BountyColors.neonRed,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
