import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/bounty_colors.dart';
import '../../../map_poster/domain/entities/bounty_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  HUNTER ALERT OVERLAY — "Accept Tray" Expanded
//
//  Shown when a Hunter taps an active Bounty Pin on the map.
//  Design: Premium OLED dark mode. Pulsating neon red urgent pin.
//  Bottom Sheet: Blurred, slide-up Accept Tray with full bounty context.
// ─────────────────────────────────────────────────────────────────────────────

class HunterAlertOverlay extends StatefulWidget {
  const HunterAlertOverlay({
    super.key,
    required this.bounty,
    required this.onAccept,
    required this.onDismiss,
  });

  final BountyEntity bounty;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  State<HunterAlertOverlay> createState() => _HunterAlertOverlayState();
}

class _HunterAlertOverlayState extends State<HunterAlertOverlay>
    with TickerProviderStateMixin {
  // Pulsating halo around the urgent pin
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // Slide-up tray entrance
  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideOffset;

  // FAB green pulse
  late final AnimationController _fabCtrl;
  late final Animation<double> _fabGlow;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: false);
    _pulseScale = Tween<double>(begin: 0.8, end: 2.2).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    )..forward();
    _slideOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _fabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _fabGlow = Tween<double>(begin: 4, end: 18).animate(
      CurvedAnimation(parent: _fabCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _slideCtrl.dispose();
    _fabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Layer 0: Dimmed desaturated map ──────────────────────────────────
        Positioned.fill(
          child: _DimmedMapBackground(),
        ),

        // ── Layer 1: Top bar "BOUNTY GHOST | Nearby" ─────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _HunterTopBar(),
        ),

        // ── Layer 2: Pulsating Urgent Pin (center, above tray) ───────────────
        Positioned(
          top: 160,
          left: 0,
          right: 0,
          child: Center(
            child: _PulsatingUrgentPin(
              bounty: widget.bounty,
              pulseScale: _pulseScale,
              pulseOpacity: _pulseOpacity,
            ),
          ),
        ),

        // ── Layer 3: Dimmed FAB (green pulsing) ──────────────────────────────
        Positioned(
          right: 20,
          bottom: 380,
          child: _DimmedFab(glowAnim: _fabGlow),
        ),

        // ── Layer 4: Accept Tray ──────────────────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SlideTransition(
            position: _slideOffset,
            child: _AcceptTray(
              bounty: widget.bounty,
              onAccept: widget.onAccept,
              onDismiss: widget.onDismiss,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Dimmed Map Background ────────────────────────────────────────────────────

class _DimmedMapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        // Deep dark grid
        Container(
          color: const Color(0xFF020406),
          child: CustomPaint(
            painter: _DimmedGridPainter(),
            child: const SizedBox.expand(),
          ),
        ),
        // Heavy dark overlay (desaturation effect)
        Container(
          color: const Color(0xCC020406),
        ),
        // Grayed-out merchant location pins
        ..._grayedPins(size),
        // Dimmed hunter cyan dots
        ..._hunterDots(size),
      ],
    );
  }

  List<Widget> _grayedPins(Size size) {
    final pins = [
      (0.12, 0.28, "Ravi's Stall"),
      (0.68, 0.20, 'H&M'),
      (0.78, 0.44, 'Café Corner'),
      (0.22, 0.58, 'BookWorld'),
      (0.52, 0.65, 'MediPlus'),
      (0.38, 0.34, 'Metro Stop'),
    ];
    return pins
        .map(
          (p) => Positioned(
            left: size.width * p.$1,
            top: size.height * p.$2,
            child: Opacity(
              opacity: 0.14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xFF3A3A3A), width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white54, size: 9),
                    const SizedBox(width: 3),
                    Text(
                      p.$3,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _hunterDots(Size size) {
    final dots = [
      (0.28, 0.32),
      (0.72, 0.36),
      (0.44, 0.50),
      (0.18, 0.46),
      (0.60, 0.28),
    ];
    return dots
        .map(
          (d) => Positioned(
            left: size.width * d.$1,
            top: size.height * d.$2,
            child: Opacity(
              opacity: 0.18,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: BountyColors.neonCyan,
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

class _DimmedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF1A1A2E).withAlpha(60)
      ..strokeWidth = 0.3;
    const spacing = 40.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    final dotPaint = Paint()
      ..color = const Color(0xFF00FFFF).withAlpha(18);
    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Hunter Top Bar ───────────────────────────────────────────────────────────

class _HunterTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, topPad + 10, 16, 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xDD050810), Color(0x88050810)],
            ),
          ),
          child: Row(
            children: [
              // Ghost icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BountyColors.neonGreen.withAlpha(30),
                  border: Border.all(
                      color: BountyColors.neonGreen.withAlpha(120), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                        color: BountyColors.glowGreen,
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
                ),
                child: const Center(
                  child: Text('👻', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'BOUNTY GHOST',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.5,
                            ),
                          ),
                          TextSpan(
                            text: '  |  Nearby',
                            style: GoogleFonts.poppins(
                              color: BountyColors.neonCyan,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '🟢 HUNTER MODE ACTIVE',
                      style: GoogleFonts.poppins(
                        color: BountyColors.neonGreen,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              // User avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: BountyColors.neonGreen.withAlpha(160), width: 2),
                  boxShadow: const [
                    BoxShadow(
                        color: BountyColors.glowGreen,
                        blurRadius: 8,
                        spreadRadius: 1)
                  ],
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=3'),
                  backgroundColor: BountyColors.backgroundLayer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pulsating Urgent Pin ─────────────────────────────────────────────────────

class _PulsatingUrgentPin extends StatelessWidget {
  const _PulsatingUrgentPin({
    required this.bounty,
    required this.pulseScale,
    required this.pulseOpacity,
  });

  final BountyEntity bounty;
  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsating ring
              AnimatedBuilder(
                animation: pulseScale,
                builder: (_, __) => Transform.scale(
                  scale: pulseScale.value,
                  child: Opacity(
                    opacity: pulseOpacity.value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: BountyColors.neonRed, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              // Middle glow ring
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BountyColors.neonRed.withAlpha(25),
                  border:
                      Border.all(color: BountyColors.neonRed.withAlpha(100), width: 1),
                  boxShadow: const [
                    BoxShadow(
                        color: BountyColors.glowRed,
                        blurRadius: 20,
                        spreadRadius: 6),
                    BoxShadow(
                        color: BountyColors.glowRed,
                        blurRadius: 40,
                        spreadRadius: 2),
                  ],
                ),
              ),
              // Core pin chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: BountyColors.backgroundCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: BountyColors.neonRed, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                        color: BountyColors.glowRed,
                        blurRadius: 14,
                        spreadRadius: 2),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🚨', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      bounty.rewardDisplay,
                      style: GoogleFonts.poppins(
                        color: BountyColors.neonRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '⚡ URGENT BOUNTY',
          style: GoogleFonts.poppins(
            color: BountyColors.neonRed,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          bounty.title,
          style: GoogleFonts.poppins(
            color: BountyColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Dimmed FAB ───────────────────────────────────────────────────────────────

class _DimmedFab extends StatelessWidget {
  const _DimmedFab({required this.glowAnim});
  final Animation<double> glowAnim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) => Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: BountyColors.backgroundCard,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: BountyColors.neonGreen.withAlpha(120), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: BountyColors.glowGreen,
                blurRadius: glowAnim.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded,
                  color: BountyColors.neonGreen, size: 16),
              const SizedBox(width: 6),
              Text(
                'Live Bounties (5)',
                style: GoogleFonts.poppins(
                  color: BountyColors.neonGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Accept Tray ──────────────────────────────────────────────────────────────

class _AcceptTray extends StatelessWidget {
  const _AcceptTray({
    required this.bounty,
    required this.onAccept,
    required this.onDismiss,
  });

  final BountyEntity bounty;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xEE0D1117), Color(0xFF060A0F)],
            ),
            border: Border(
              top: BorderSide(color: Color(0xFF2A2A3A), width: 0.8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ────────────────────────────────────────────────
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BountyColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Poster info ──────────────────────────────────────────
                    _PosterInfo(bounty: bounty),
                    const SizedBox(height: 14),

                    // ── Video thumbnail ─────────────────────────────────────
                    _VideoThumbnail(bounty: bounty),
                    const SizedBox(height: 14),

                    // ── Transcription ────────────────────────────────────────
                    _TranscriptionText(bounty: bounty),
                    const SizedBox(height: 14),

                    // ── Metrics row ──────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBox(
                            icon: Icons.access_time_rounded,
                            label: 'ETA',
                            value: '4 mins',
                            color: BountyColors.neonCyan,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricBox(
                            icon: Icons.location_on_rounded,
                            label: 'Distance',
                            value: '120m',
                            color: BountyColors.neonCyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Payout label ─────────────────────────────────────────
                    Center(
                      child: Text(
                        '⚡ Payout released instantly upon delivery.',
                        style: GoogleFonts.poppins(
                          color: BountyColors.textDisabled,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Action buttons ───────────────────────────────────────
                    _ActionButtons(
                      bounty: bounty,
                      onAccept: onAccept,
                      onDismiss: onDismiss,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Poster Info ──────────────────────────────────────────────────────────────

class _PosterInfo extends StatelessWidget {
  const _PosterInfo({required this.bounty});
  final BountyEntity bounty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: BountyColors.neonGreen, width: 2),
            boxShadow: const [
              BoxShadow(
                  color: BountyColors.glowGreen,
                  blurRadius: 10,
                  spreadRadius: 1),
            ],
          ),
          child: const CircleAvatar(
            radius: 20,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?img=47'),
            backgroundColor: BountyColors.backgroundLayer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    bounty.posterName,
                    style: GoogleFonts.poppins(
                      color: BountyColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Stars
                  Row(
                    children: List.generate(
                      5,
                      (i) => const Icon(Icons.star_rounded,
                          color: Color(0xFFFFD700), size: 13),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '4.9',
                    style: GoogleFonts.poppins(
                      color: BountyColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              // Trust badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: BountyColors.neonGreen.withAlpha(22),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: BountyColors.neonGreen.withAlpha(100), width: 0.8),
                  boxShadow: const [
                    BoxShadow(
                        color: BountyColors.glowGreen,
                        blurRadius: 8,
                        spreadRadius: 0),
                  ],
                ),
                child: Text(
                  '✓  98% TRUST  •  ELITE',
                  style: GoogleFonts.poppins(
                    color: BountyColors.neonGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Time posted
        Text(
          '2m ago',
          style: GoogleFonts.poppins(
            color: BountyColors.textDisabled,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ─── Video Thumbnail ──────────────────────────────────────────────────────────

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({required this.bounty});
  final BountyEntity bounty;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2018), Color(0xFF090F1E)],
        ),
        border: Border.all(color: BountyColors.divider, width: 0.8),
        boxShadow: const [
          BoxShadow(
              color: BountyColors.glowGreen,
              blurRadius: 16,
              spreadRadius: 0,
              offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background food emoji art
            Center(
              child: Opacity(
                opacity: 0.22,
                child: const Text('🍛', style: TextStyle(fontSize: 80)),
              ),
            ),
            // Scanline overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF000000).withAlpha(120),
                  ],
                ),
              ),
            ),
            // Center play button
            Center(
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BountyColors.neonGreen.withAlpha(30),
                  border: Border.all(
                      color: BountyColors.neonGreen, width: 2),
                  boxShadow: const [
                    BoxShadow(
                        color: BountyColors.glowGreen,
                        blurRadius: 20,
                        spreadRadius: 4),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: BountyColors.neonGreen,
                  size: 30,
                ),
              ),
            ),
            // ▶ 3s badge (top right)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: BountyColors.neonRed.withAlpha(220),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '▶  3s LOOP',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            // Poster name at bottom
            Positioned(
              bottom: 10,
              left: 12,
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: BountyColors.neonGreen.withAlpha(40),
                      border: Border.all(
                          color: BountyColors.neonGreen, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        bounty.posterName.isNotEmpty
                            ? bounty.posterName[0]
                            : 'S',
                        style: GoogleFonts.poppins(
                          color: BountyColors.neonGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    bounty.posterName,
                    style: GoogleFonts.poppins(
                      color: BountyColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Waveform at very bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _WaveformBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveformBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(28, (i) {
          final heights = [
            4.0, 8.0, 12.0, 6.0, 14.0, 10.0, 5.0, 16.0, 8.0, 11.0,
            7.0, 13.0, 5.0, 10.0, 15.0, 7.0, 9.0, 14.0, 6.0, 12.0,
            8.0, 10.0, 5.0, 13.0, 7.0, 9.0, 4.0, 11.0
          ];
          return Container(
            width: 2.5,
            height: heights[i % heights.length],
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: BountyColors.neonGreen.withAlpha(120),
              borderRadius: BorderRadius.circular(1),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Transcription Text ───────────────────────────────────────────────────────

class _TranscriptionText extends StatelessWidget {
  const _TranscriptionText({required this.bounty});
  final BountyEntity bounty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1A),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: BountyColors.divider.withAlpha(80), width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎙 Poster Audio',
            style: GoogleFonts.poppins(
              color: BountyColors.textDisabled,
              fontSize: 9.5,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: BountyColors.textPrimary,
                fontSize: 15.5,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
              children: [
                const TextSpan(text: '"Need '),
                TextSpan(
                  text: 'Masala Dosa',
                  style: GoogleFonts.poppins(
                    color: BountyColors.neonCyan,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: "Ravi's Stall",
                  style: GoogleFonts.poppins(
                    color: BountyColors.neonCyan,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
                const TextSpan(text: '. Extra ghee. '),
                TextSpan(
                  text: '₹50 bounty',
                  style: GoogleFonts.poppins(
                    color: BountyColors.neonGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
                const TextSpan(text: '."'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Metric Box ───────────────────────────────────────────────────────────────

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80), width: 0.8),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: BountyColors.textDisabled,
                  fontSize: 9.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.bounty,
    required this.onAccept,
    required this.onDismiss,
  });

  final BountyEntity bounty;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ACCEPT — neon green, prominent
        Expanded(
          flex: 3,
          child: _TactileButton(
            onTap: onAccept,
            color: BountyColors.neonGreen,
            glowColor: BountyColors.glowGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👻', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCEPT',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      bounty.rewardDisplay,
                      style: GoogleFonts.poppins(
                        color: Colors.black.withAlpha(170),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // DISMISS — muted gray
        Expanded(
          flex: 2,
          child: _TactileButton(
            onTap: onDismiss,
            color: BountyColors.divider,
            glowColor: Colors.transparent,
            textOnly: true,
            child: Text(
              'DISMISS',
              style: GoogleFonts.poppins(
                color: BountyColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TactileButton extends StatefulWidget {
  const _TactileButton({
    required this.onTap,
    required this.color,
    required this.glowColor,
    required this.child,
    this.textOnly = false,
  });

  final VoidCallback onTap;
  final Color color;
  final Color glowColor;
  final Widget child;
  final bool textOnly;

  @override
  State<_TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<_TactileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform:
            Matrix4.identity()..scale(_pressed ? 0.96 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: widget.textOnly
              ? BountyColors.backgroundLayer
              : widget.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.textOnly
                ? BountyColors.divider
                : widget.color.withAlpha(200),
            width: 1,
          ),
          boxShadow: _pressed || widget.textOnly
              ? []
              : [
                  BoxShadow(
                    color: widget.glowColor,
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: widget.glowColor,
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
