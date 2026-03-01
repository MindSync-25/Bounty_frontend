import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/bounty_colors.dart';

/// [HunterMapPage] — Placeholder for Phase 1.
///
/// Phase 2: Extends UnifiedMapPage with Hunter-mode overlays:
///   - Neon Green markers for available bounties
///   - Live WebSocket position tracking via stomp_dart_client
///   - Route polyline to accepted bounty
class HunterMapPage extends StatelessWidget {
  const HunterMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BountyColors.backgroundDeep,
      appBar: AppBar(
        title: Text(
          'HUNTER MODE',
          style: GoogleFonts.poppins(
            color: BountyColors.neonGreen,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: BountyColors.neonGreen, width: 2),
                boxShadow: const [
                  BoxShadow(color: BountyColors.glowGreen, blurRadius: 24),
                ],
              ),
              child: const Icon(
                Icons.sports_esports_outlined,
                color: BountyColors.neonGreen,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '🎯 Hunter Mode',
              style: GoogleFonts.poppins(
                color: BountyColors.neonGreen,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming in Phase 2',
              style: GoogleFonts.poppins(
                color: BountyColors.textDisabled,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
