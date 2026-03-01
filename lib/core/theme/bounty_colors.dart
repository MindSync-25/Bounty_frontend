import 'package:flutter/material.dart';

/// [BountyColors] — Premium Dark Palette for Bounty Ghost.
///
/// UI Spec: Ghost App Design System v1.0
/// ─────────────────────────────────────────────────────────────────────────────
///  BACKGROUND STACK   → backgroundDeep → backgroundCard → backgroundLayer
///  NEON ACCENTS       → Cyan (Poster) | Green (Hunter) | Red (Alert/Danger)
///  TEXT HIERARCHY     → textPrimary → textSecondary → textDisabled
///  GLOW EFFECTS       → glowCyan / glowGreen / glowRed (shadow color)
/// ─────────────────────────────────────────────────────────────────────────────
abstract final class BountyColors {
  // ── Backgrounds ─────────────────────────────────────────────────────────────
  /// Deepest background — map screen, root scaffolds. #050810
  static const Color backgroundDeep = Color(0xFF050810);

  /// Card / bottom sheet surface. #0D1117
  static const Color backgroundCard = Color(0xFF0D1117);

  /// Elevated UI layer — dialogs, menus. #161B22
  static const Color backgroundLayer = Color(0xFF161B22);

  // ── Neon Accents ─────────────────────────────────────────────────────────────
  /// Primary CTAs, active bounty markers, Poster mode. #00FFFF
  static const Color neonCyan = Color(0xFF00FFFF);

  /// Hunter mode, success states, completion. #00FF00
  static const Color neonGreen = Color(0xFF00FF00);

  /// Danger, urgent bounties, cancel, errors. #FF0000
  static const Color neonRed = Color(0xFFFF0000);

  // ── Supporting Neutrals ──────────────────────────────────────────────────────
  /// Borders, dividers, separator lines. #444444
  static const Color divider = Color(0xFF444444);

  /// Primary body text / headings. #E6EDF3
  static const Color textPrimary = Color(0xFFE6EDF3);

  /// Muted / secondary labels. #8B949E
  static const Color textSecondary = Color(0xFF8B949E);

  /// Disabled state text / icons. #484F58
  static const Color textDisabled = Color(0xFF484F58);

  // ── Semantic Aliases ─────────────────────────────────────────────────────────
  /// Used when UI is in Poster (posting bounty) mode.
  static const Color posterMode = neonCyan;

  /// Used when UI is in Hunter (hunting bounty) mode.
  static const Color hunterMode = neonGreen;

  /// Used for urgent, expiring-soon, or error states.
  static const Color alertMode = neonRed;

  // ── Glow / Shadow Colors (with opacity for BoxShadow use) ────────────────────
  /// 27% opacity cyan glow — for poster-mode highlights & neon borders.
  static const Color glowCyan = Color(0x4400FFFF);

  /// 27% opacity green glow — for hunter-mode highlights.
  static const Color glowGreen = Color(0x4400FF00);

  /// 27% opacity red glow — for alert / danger highlights.
  static const Color glowRed = Color(0x44FF0000);

  // ── Overlay ──────────────────────────────────────────────────────────────────
  /// Semi-transparent overlay for map modals / sheets.
  static const Color mapOverlay = Color(0xCC050810);

  /// Gradient start for reward badge.
  static const Color rewardGradientStart = Color(0xFF00FFFF);

  /// Gradient end for reward badge.
  static const Color rewardGradientEnd = Color(0xFF0088AA);
}
