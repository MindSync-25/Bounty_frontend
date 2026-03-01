import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/bounty_colors.dart';
import '../../domain/entities/bounty_entity.dart';
import '../bloc/map_poster_bloc.dart';
import '../bloc/map_poster_event.dart';

/// Peek card displayed when a user selects a bounty marker on the map.
/// Shows key info with one-tap Accept or Dismiss.
class BountyBottomSheet extends StatelessWidget {
  const BountyBottomSheet({required this.bounty, super.key});
  final BountyEntity bounty;

  Color get _accentColor =>
      bounty.isUrgent ? BountyColors.neonRed : BountyColors.neonCyan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: BountyColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withAlpha(60),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────────
            Row(
              children: [
                if (bounty.isUrgent)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: BountyColors.glowRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🚨 URGENT',
                      style: GoogleFonts.poppins(
                        color: BountyColors.neonRed,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    bounty.title,
                    style: GoogleFonts.poppins(
                      color: BountyColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _accentColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _accentColor, width: 1),
                  ),
                  child: Text(
                    bounty.rewardDisplay,
                    style: GoogleFonts.poppins(
                      color: _accentColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Description ─────────────────────────────────────────────────
            Text(
              bounty.description,
              style: GoogleFonts.poppins(
                color: BountyColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // ── Meta row ────────────────────────────────────────────────────
            Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=7',
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  bounty.posterName,
                  style: GoogleFonts.poppins(
                    color: BountyColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.location_on_outlined,
                  color: BountyColors.textDisabled,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  '${bounty.distanceKm.toStringAsFixed(1)} km',
                  style: GoogleFonts.poppins(
                    color: BountyColors.textDisabled,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.access_time,
                  color: BountyColors.textDisabled,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  bounty.categoryLabel,
                  style: GoogleFonts.poppins(
                    color: BountyColors.textDisabled,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Actions ─────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context
                        .read<MapPosterBloc>()
                        .add(const DeselectBounty()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BountyColors.textSecondary,
                      side: const BorderSide(color: BountyColors.divider),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Dismiss'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Phase 1: Navigate to hunter detail / accept flow
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: BountyColors.backgroundDeep,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      bounty.isUrgent ? '🚨 Accept Now' : '👻 Hunt This',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
