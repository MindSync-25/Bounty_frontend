import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/bounty_colors.dart';
import '../../../../data/mock_services/i_bounty_service.dart';
import '../../../../data/mock_services/mock_models/mock_bounty.dart';
import '../../data/repositories_impl/bounty_repository_impl.dart';
import '../../domain/entities/bounty_entity.dart';
import '../bloc/map_poster_bloc.dart';
import '../bloc/map_poster_event.dart';
import '../bloc/map_poster_state.dart';

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  THE WAR MAP Ã¢â‚¬â€ Bounty Ghost's core map screen
//  Poster Mode:  "I NEED" active Ã¢â‚¬â€ post bounties via voice/text
//  Hunter Mode:  "I'M FREE" active Ã¢â‚¬â€ accept nearby live bounties
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

/// [UnifiedMapPage] Ã¢â‚¬â€ The Ghost App's core screen.
///
/// "Contextual Unified UI" Ã¢â‚¬â€ a single immersive map-centric view.
/// No explicit mode switching. The UI adapts based on user action.
///
/// Phase 1: Renders a styled placeholder grid instead of real Google Map.
///   Ã¢â€ â€™ Replace [_MapPlaceholder] with [GoogleMap(...)] after API key setup.
/// Phase 2: Real map tiles + live WebSocket markers.
class UnifiedMapPage extends StatelessWidget {
  const UnifiedMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapPosterBloc(
        repository: BountyRepositoryImpl(service: sl<IBountyService>()),
      )..add(const LoadNearbyBounties(lat: 37.7751, lng: -122.4194)),
      child: const _UnifiedMapView(),
    );
  }
}

class _UnifiedMapView extends StatelessWidget {
  const _UnifiedMapView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapPosterBloc, MapPosterState>(
      listenWhen: (_, curr) => curr is BountyPostedSuccess,
      listener: (context, state) {
        if (state is BountyPostedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: BountyColors.backgroundCard,
              content: Row(children: [
                const Icon(Icons.check_circle, color: BountyColors.neonGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ã°Å¸â€˜Â» Bounty Posted! "${state.bounty.title}"',
                    style: GoogleFonts.poppins(
                      color: BountyColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]),
            ),
          );
        }
      },
      builder: (context, state) {
        final loaded = state is MapPosterLoaded ? state : null;
        final isHunter = loaded?.isHunterMode ?? false;
        final bounties = loaded?.bounties ?? <BountyEntity>[];
        final selected = loaded?.selectedBounty;

        return Scaffold(
          backgroundColor: BountyColors.backgroundDeep,
          body: Stack(
            children: [
              // Real map â€” CartoDB Dark Matter + OpenStreetMap (no API key)
              Positioned.fill(
                child: _RealMap(
                  isHunterMode: isHunter,
                  bounties: bounties,
                  selectedBountyId: selected?.id,
                  onBountyTap: (id) => context
                      .read<MapPosterBloc>()
                      .add(SelectBounty(bountyId: id)),
                ),
              ),

              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 5: "LIVE BOUNTIES" label (hunter, no selection) Ã¢â€â‚¬
              // Layer 5: Live Bounties FAB - mode toggle
              if (selected == null)
                isHunter
                  ? Positioned(
                      left: 0, right: 0, bottom: 106,
                      child: Center(
                        child: _LiveBountiesFab(
                          count: bounties.length,
                          isHunter: isHunter,
                          onTap: () => context.read<MapPosterBloc>().add(const ToggleHunterMode()),
                        ),
                      ),
                    )
                  : Positioned(
                      right: 16, bottom: 108,
                      child: _LiveBountiesFab(
                        count: bounties.length,
                        isHunter: isHunter,
                        onTap: () => context.read<MapPosterBloc>().add(const ToggleHunterMode()),
                      ),
                    ),

              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 6: Map header (title + toggle) Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
              Positioned(
                top: 0, left: 0, right: 0,
                child: _MapHeader(isHunterMode: isHunter),
              ),

              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 7: Navigation arrow (top right) Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
              const Positioned(
                top: 72, right: 16,
                child: _NavigationArrowButton(),
              ),

              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 8: Quick post bar (poster, no selection) Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
              if (!isHunter && selected == null)
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: _QuickPostBar(
                    onPost: (_) => context
                        .read<MapPosterBloc>()
                        .add(const OpenPostBountySheet()),
                  ),
                ),

              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 9: Leaderboard strip (hunter, no selection) Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬


              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 10: Bounty found card (hunter + selected) Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
              if (isHunter && selected != null)
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: _BountyFoundCard(
                    bounty: selected,
                    onAccept: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: BountyColors.backgroundCard,
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: BountyColors.neonGreen),
                            const SizedBox(width: 12),
                            Text('Ã°Å¸â€˜Â» Bounty Accepted! Get moving.',
                              style: GoogleFonts.poppins(
                                color: BountyColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                        ),
                      );
                      context.read<MapPosterBloc>().add(const DeselectBounty());
                    },
                    onReject: () => context
                        .read<MapPosterBloc>()
                        .add(const DeselectBounty()),
                  ),
                ),

              // Ã¢â€â‚¬Ã¢â€â‚¬ Layer 11: Loading overlay Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
              if (state is MapPosterLoading) const _LoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  MAP HEADER Ã¢â‚¬â€ "BOUNTY" title + I NEED / I'M FREE segmented toggle
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _MapHeader extends StatelessWidget {
  const _MapHeader({required this.isHunterMode});
  final bool isHunterMode;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                BountyColors.backgroundDeep.withAlpha(200),
                BountyColors.backgroundDeep.withAlpha(80),
                Colors.transparent,
              ],
              stops: const [0.0, 0.65, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Row(
                children: [
                  Icon(Icons.menu_rounded, color: Colors.white.withAlpha(180), size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'BOUNTY',
                    style: GoogleFonts.poppins(
                      color: BountyColors.neonCyan.withAlpha(160),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: BountyColors.neonGreen.withAlpha(30),
                    child: Icon(Icons.person_rounded, color: BountyColors.neonGreen.withAlpha(180), size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}
//  LIVE BOUNTIES FAB u{2014} one-tap mode toggle pill
// u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}u{2500}

class _LiveBountiesFab extends StatelessWidget {
  const _LiveBountiesFab({
    required this.count,
    required this.isHunter,
    required this.onTap,
  });
  final int count;
  final bool isHunter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isHunter
        ? BountyColors.neonRed.withAlpha(210)
        : const Color(0xFF00FF88).withAlpha(185);
    final borderColor = isHunter
        ? BountyColors.neonRed.withAlpha(130)
        : const Color(0xFF00FF88).withAlpha(115);
    final glowColor = isHunter
        ? BountyColors.neonRed.withAlpha(45)
        : const Color(0xFF00FF88).withAlpha(35);
    final label = isHunter
        ? 'Live Bounties ($count)'
        : 'Live Bounties ($count)';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(160),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHunter ? Icons.notifications_rounded : Icons.wifi_tethering_rounded,
              color: fg, size: 11,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: fg,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _RealMap extends StatefulWidget {
  const _RealMap({
    required this.isHunterMode,
    required this.bounties,
    required this.onBountyTap,
    this.selectedBountyId,
  });

  final bool isHunterMode;
  final List<BountyEntity> bounties;
  final void Function(String id) onBountyTap;
  final String? selectedBountyId;

  // Bangalore city centre
  static const _center = LatLng(12.9716, 77.5946);

  // Fixed bounty pin positions (500mâ€“1.5km radius)
  static const _bountyPositions = [
    LatLng(12.9768, 77.5888),
    LatLng(12.9680, 77.6012),
    LatLng(12.9800, 77.5960),
    LatLng(12.9652, 77.5900),
    LatLng(12.9740, 77.6040),
  ];

  // Active-hunter cyan dot positions
  static const _hunterDots = [
    LatLng(12.9772, 77.5920), LatLng(12.9700, 77.6030), LatLng(12.9840, 77.5890),
    LatLng(12.9660, 77.5980), LatLng(12.9790, 77.6010), LatLng(12.9630, 77.5860),
    LatLng(12.9720, 77.5800), LatLng(12.9820, 77.6070), LatLng(12.9600, 77.6040),
    LatLng(12.9760, 77.5750), LatLng(12.9880, 77.5930), LatLng(12.9670, 77.6110),
    LatLng(12.9900, 77.5830),
  ];

  // Merchant hot-zone rectangles (poster mode)
  static const _zones = [
    [LatLng(12.9750, 77.5890), LatLng(12.9750, 77.5940), LatLng(12.9720, 77.5940), LatLng(12.9720, 77.5890)],
    [LatLng(12.9700, 77.5980), LatLng(12.9700, 77.6040), LatLng(12.9670, 77.6040), LatLng(12.9670, 77.5980)],
    [LatLng(12.9800, 77.6000), LatLng(12.9800, 77.6060), LatLng(12.9770, 77.6060), LatLng(12.9770, 77.6000)],
  ];

  static const _zoneLabels = ["Ravi's Dosa", 'H&M Store', 'Supermart'];

  static const _merchantPositions = [
    LatLng(12.9735, 77.5915),
    LatLng(12.9685, 77.6010),
    LatLng(12.9785, 77.6030),
    LatLng(12.9710, 77.5870),
    LatLng(12.9850, 77.5950),
  ];
  static const _merchantNames = ["Ravi's Dosa", 'H&M Store', 'Supermart', 'Chai Point', 'FreshMart'];

  @override
  State<_RealMap> createState() => _RealMapState();
}

class _RealMapState extends State<_RealMap> {
  late final MapController _mapCtrl;

  @override
  void initState() {
    super.initState();
    _mapCtrl = MapController();
  }

  @override
  void dispose() {
    _mapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHunter = widget.isHunterMode;
    final bounties = widget.bounties;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        // Subtle cool tint — matches mockup tone
        0.95, 0.00, 0.00, 0, 0,
        0.00, 0.97, 0.02, 0, 0,
        0.05, 0.03, 1.00, 0, 8,
        0.00, 0.00, 0.00, 1, 0,
      ]),
      child: FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        initialCenter: _RealMap._center,
        initialZoom: 15.0,
        minZoom: 12.0,
        maxZoom: 19.0,
      ),
      children: [
        // Dark map tiles â€” CartoDB Dark Matter (perfect for neon UI, free)
        TileLayer(
          urlTemplate:
              'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.bountyghost.app',
          maxZoom: 19,
          tileProvider: CancellableNetworkTileProvider(),
        ),

        // Active hunter cyan dots
        CircleLayer(
          circles: [
            for (final dot in _RealMap._hunterDots)
              CircleMarker(
                point: dot,
                radius: 6,
                color: BountyColors.neonCyan.withAlpha(105),
                borderColor: BountyColors.neonCyan.withAlpha(160),
                borderStrokeWidth: 1.0,
                useRadiusInMeter: false,
              ),
          ],
        ),

        // Bounty pins (poster = chip label, hunter = drop pin)
        MarkerLayer(
          markers: [
            for (var i = 0;
                i < bounties.length &&
                    i < _RealMap._bountyPositions.length;
                i++)
              Marker(
                point: _RealMap._bountyPositions[i],
                width: isHunter ? 58 : 50,
                height: isHunter ? 62 : 22,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => widget.onBountyTap(bounties[i].id),
                  child: isHunter
                      ? _DropPin(
                          isRed: bounties[i].isUrgent || i < 3,
                          isSelected: widget.selectedBountyId == bounties[i].id,
                        )
                      : _PinChip(bounty: bounties[i]),
                ),
              ),
          ],
        ),

        // Merchant hot zone markers
        MarkerLayer(
          markers: [
            for (var i = 0; i < _RealMap._merchantPositions.length; i++)
              Marker(
                point: _RealMap._merchantPositions[i],
                width: 72,
                height: 44,
                alignment: Alignment.topCenter,
                child: _MerchantPin(name: _RealMap._merchantNames[i]),
              ),
          ],
        ),
      ],
      ),
    );
  }
}

class _PinChip extends StatelessWidget {
  const _PinChip({required this.bounty});
  final BountyEntity bounty;

  @override
  Widget build(BuildContext context) {
    final color = bounty.isUrgent ? BountyColors.neonRed : BountyColors.neonCyan;
    final reward = (bounty.rewardCents / 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(190),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(150), width: 0.8),
        boxShadow: [
          BoxShadow(color: color.withAlpha(70), blurRadius: 8, spreadRadius: 0),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.currency_rupee_rounded, color: color.withAlpha(210), size: 7),
          Text(
            '$reward',
            style: GoogleFonts.poppins(
              color: color.withAlpha(230),
              fontSize: 8,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  LIVE BOUNTY PINS Ã¢â‚¬â€ Red/gold drop-pins in hunter mode
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _MerchantPin extends StatelessWidget {
  const _MerchantPin({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BountyColors.neonCyan.withAlpha(22),
            border: Border.all(color: BountyColors.neonCyan.withAlpha(110), width: 1),
          ),
          child: Icon(Icons.storefront_rounded, color: BountyColors.neonCyan.withAlpha(170), size: 11),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: Colors.white.withAlpha(180),
            fontSize: 7,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _DropPin extends StatelessWidget {
  const _DropPin({required this.isRed, this.isSelected = false});
  final bool isRed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isRed ? BountyColors.neonRed : const Color(0xFFFFBB33);
    final pinW = isSelected ? 32.0 : 26.0;
    final pinH = pinW * 1.38;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Pulsing outer ring when selected
        if (isSelected)
          Container(
            width: pinW + 18,
            height: pinW + 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withAlpha(120), width: 1.5),
              boxShadow: [
                BoxShadow(color: color.withAlpha(55), blurRadius: 20, spreadRadius: 5),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: isSelected ? 9.0 : 0),
          child: CustomPaint(
            painter: _TearDropPainter(color: color),
            size: Size(pinW, pinH),
            child: SizedBox(
              width: pinW,
              height: pinH,
              child: Align(
                alignment: const Alignment(0, -0.3),
                child: Icon(
                  isRed ? Icons.bolt_rounded : Icons.currency_rupee_rounded,
                  color: Colors.white.withAlpha(230),
                  size: pinW * 0.46,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TearDropPainter extends CustomPainter {
  const _TearDropPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w / 2;
    final cx = w / 2;

    // Outer glow
    canvas.drawCircle(
      Offset(cx, r), r,
      Paint()
        ..color = color.withAlpha(55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Teardrop path: circle top + pointed tail
    final fill = Paint()
      ..color = color.withAlpha(220)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, r), radius: r))
      ..moveTo(cx - r * 0.42, r + r * 0.60)
      ..lineTo(cx, h)
      ..lineTo(cx + r * 0.42, r + r * 0.60)
      ..close();

    canvas.drawPath(path, fill);

    // Inner depth circle
    canvas.drawCircle(
      Offset(cx, r), r * 0.66,
      Paint()
        ..color = Colors.black.withAlpha(50)
        ..style = PaintingStyle.fill,
    );

    // White rim highlight
    canvas.drawCircle(
      Offset(cx, r), r - 0.5,
      Paint()
        ..color = Colors.white.withAlpha(30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  POSTER MODE LABELS Ã¢â‚¬â€ Left callout annotations
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _PosterModeLabels extends StatelessWidget {
  const _PosterModeLabels();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Positioned(
          left: 8, top: size.height * 0.32,
          child: const _CalloutLabel(text: 'ACTIVE\nHUNTERS\nNEARBY', color: BountyColors.neonCyan),
        ),
        Positioned(
          left: 8, top: size.height * 0.49,
          child: const _CalloutLabel(text: 'MERCHANT\nHOT ZONES', color: Color(0xFFFFD700)),
        ),
      ],
    );
  }
}

class _CalloutLabel extends StatelessWidget {
  const _CalloutLabel({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: BountyColors.backgroundCard.withAlpha(200),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withAlpha(100), width: 0.5),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: color, fontSize: 7.5, fontWeight: FontWeight.w700,
              letterSpacing: 0.5, height: 1.4,
            ),
          ),
        ),
        Icon(Icons.arrow_right, color: color, size: 16),
      ],
    );
  }
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  LIVE BOUNTIES LABEL Ã¢â‚¬â€ Hunter mode top right badge
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _LiveBountiesLabel extends StatelessWidget {
  const _LiveBountiesLabel();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 58, top: 118,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(120),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BountyColors.neonRed.withAlpha(120), width: 0.5),
          boxShadow: [BoxShadow(color: BountyColors.neonRed.withAlpha(40), blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 5, height: 5,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: BountyColors.neonRed)),
            const SizedBox(width: 5),
            Text('LIVE BOUNTIES',
                style: GoogleFonts.poppins(
                  color: BountyColors.neonRed, fontSize: 9, fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                )),
          ],
        ),
      ),
    );
  }
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  NAVIGATION ARROW BUTTON
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _NavigationArrowButton extends StatelessWidget {
  const _NavigationArrowButton();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(15),
            border: Border.all(color: Colors.white.withAlpha(30), width: 0.5),
          ),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Icon(Icons.navigation_rounded, color: BountyColors.neonCyan.withAlpha(200), size: 15),
          ),
        ),
      ),
    );
  }
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  QUICK POST BAR Ã¢â‚¬â€ Poster mode bottom (Coffee | Mic FAB | Groceries)
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _QuickPostBar extends StatefulWidget {
  const _QuickPostBar({required this.onPost});
  final void Function(String text) onPost;

  @override
  State<_QuickPostBar> createState() => _QuickPostBarState();
}

class _QuickPostBarState extends State<_QuickPostBar> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _ctrl.text.trim();
    widget.onPost(text);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 64;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, bottomInset + 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(170),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: BountyColors.neonCyan.withAlpha(100),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: BountyColors.neonCyan.withAlpha(35),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BountyColors.neonCyan.withAlpha(22),
                border: Border.all(color: BountyColors.neonCyan.withAlpha(110), width: 1),
              ),
              child: Icon(Icons.mic_rounded, color: BountyColors.neonCyan.withAlpha(170), size: 11),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                controller: _ctrl,
                style: GoogleFonts.poppins(
                  color: BountyColors.textPrimary,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w300,
                ),
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Post a bounty... (e.g., Get Dosa, Wait in a Line)',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white.withAlpha(55),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w300,
                  ),
                  isDense: true,
                  filled: false,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _submit,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send_rounded, color: BountyColors.neonCyan.withAlpha(170), size: 13),
                  const SizedBox(height: 1),
                  Text(
                    'Post',
                    style: GoogleFonts.poppins(
                      color: BountyColors.neonCyan.withAlpha(145),
                      fontSize: 7,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  BOUNTY FOUND CARD Ã¢â‚¬â€ Hunter mode bottom card (bounty selected)
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _BountyFoundCard extends StatelessWidget {
  const _BountyFoundCard({
    required this.bounty,
    required this.onAccept,
    required this.onReject,
  });
  final BountyEntity bounty;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  // V3.1 palette
  static const _green  = Color(0xFF3EBD78);
  static const _cyan   = Color(0xFF00FFFF);
  static const _slate  = Color(0xFF1A1C21);
  static const _white  = Color(0xFFFFFFFF);
  static const _faded  = Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    final reward    = (bounty.rewardCents / 100).round();
    final netReward = (reward * 0.85).round();
    final dist      = (bounty.distanceKm * 1000).round();
    final expiry    = bounty.expiresAt.difference(DateTime.now());
    final expiryStr = expiry.isNegative
        ? 'EXPIRED'
        : '${expiry.inMinutes.toString().padLeft(2, '0')}:${expiry.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Container(
      // Gradient fade top â€” dark slate covers ~55% of screen bottom
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            _slate.withAlpha(80),
            _slate.withAlpha(216),
          ],
          stops: const [0.0, 0.08, 0.28],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: _slate.withAlpha(217), // ~0.85 opacity
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  border: Border.all(
                    color: _cyan.withAlpha(55), // faint cyan glow edge
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _cyan.withAlpha(18),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, -4),
                    ),
                    BoxShadow(
                      color: Colors.black.withAlpha(180),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // â”€â”€ Drag handle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Center(
                      child: Container(
                        width: 38, height: 3,
                        margin: const EdgeInsets.only(top: 6, bottom: 4),
                        decoration: BoxDecoration(
                          color: _faded.withAlpha(60),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // â”€â”€ Row 1: Trust badge | Order ID â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Green glowing avatar circle
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _green.withAlpha(18),
                              border: Border.all(color: _green.withAlpha(120), width: 1.0),
                              boxShadow: [BoxShadow(color: _green.withAlpha(40), blurRadius: 10)],
                            ),
                            child: Icon(Icons.person_rounded, color: _green.withAlpha(220), size: 13),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  bounty.posterName.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    color: _green,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    shadows: [Shadow(color: _green.withAlpha(70), blurRadius: 8)],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, color: _green.withAlpha(180), size: 9),
                                    const SizedBox(width: 2),
                                    Text(
                                      'TRUST: 98%  \u2022  ELITE',
                                      style: GoogleFonts.poppins(
                                        color: _green.withAlpha(170),
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Expiry timer
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: BountyColors.neonRed.withAlpha(18),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: BountyColors.neonRed.withAlpha(80), width: 0.7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_rounded, color: BountyColors.neonRed.withAlpha(180), size: 8),
                                const SizedBox(width: 2),
                                Text(
                                  expiryStr,
                                  style: GoogleFonts.poppins(
                                    color: BountyColors.neonRed.withAlpha(200),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // â”€â”€ Divider â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Divider(height: 1, thickness: 0.4, color: _faded.withAlpha(22)),
                    ),

                    // â”€â”€ Main title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // THE MONEY â€” max hierarchy neon green
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\u20B9$reward',
                                style: GoogleFonts.poppins(
                                  color: _green,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  shadows: [
                                    Shadow(color: _green.withAlpha(110), blurRadius: 18),
                                    Shadow(color: _green.withAlpha(50), blurRadius: 35),
                                  ],
                                ),
                              ),
                              Text(
                                'BOUNTY',
                                style: GoogleFonts.poppins(
                                  color: _green.withAlpha(140),
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '+\u20B9$netReward net (85%)',
                                style: GoogleFonts.poppins(
                                  color: _faded.withAlpha(100),
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // â”€â”€ Logistics strip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _V31Chip(icon: Icons.place_rounded,           text: '${dist}m away',      color: _green),
                          _V31Chip(icon: Icons.directions_walk_rounded,  text: '~2 min walk',        color: _cyan),
                          _V31Chip(icon: Icons.bolt_rounded,             text: bounty.isUrgent ? 'URGENT' : 'Normal', color: bounty.isUrgent ? BountyColors.neonRed : _faded),
                        ],
                      ),
                    ),

                    // â”€â”€ Voice note / description row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(60),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _faded.withAlpha(18), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            // Play button
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _green.withAlpha(18),
                                border: Border.all(color: _green.withAlpha(110), width: 0.8),
                                boxShadow: [BoxShadow(color: _green.withAlpha(35), blurRadius: 8)],
                              ),
                              child: Icon(Icons.play_arrow_rounded, color: _green.withAlpha(210), size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '"${bounty.description}"',
                                style: GoogleFonts.poppins(
                                  color: _white.withAlpha(165),
                                  fontSize: 10.5,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                  height: 1.45,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // â”€â”€ ACCEPT button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: onAccept,
                        child: Container(
                          height: 42,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A2016),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF2A5C38), width: 1.5),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF1A4A2E).withAlpha(80), blurRadius: 18, spreadRadius: 0),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'ACCEPT BOUNTY',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('\u{1F47B}', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // â”€â”€ DISMISS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    GestureDetector(
                      onTap: onReject,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: Center(
                          child: Text(
                            'DISMISS',
                            style: GoogleFonts.poppins(
                              color: _faded.withAlpha(90),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Logistics chip used in V3.1 card
class _V31Chip extends StatelessWidget {
  const _V31Chip({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(60), width: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color.withAlpha(190), size: 9.5),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: color.withAlpha(210),
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: color.withAlpha(60), blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}
class _LeaderboardStrip extends StatelessWidget {
  const _LeaderboardStrip();

  static const _hunters = [
    _HunterData('Top Hunters', '+\$25.00', 'Weekly earnings', 'https://i.pravatar.cc/80?img=12'),
    _HunterData('Aornor', '+\$25.00', 'Weekly earnings', 'https://i.pravatar.cc/80?img=23'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            BountyColors.backgroundDeep,
            BountyColors.backgroundDeep.withAlpha(220),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(width: 3, height: 12,
                    decoration: BoxDecoration(
                      color: BountyColors.neonGreen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Top Hunters',
                      style: GoogleFonts.poppins(
                        color: BountyColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2,
                      )),
                  const Spacer(),
                  Text('see all',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withAlpha(80), fontSize: 10, fontWeight: FontWeight.w400,
                      )),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _HunterCard(data: _hunters[0])),
                  const SizedBox(width: 10),
                  Expanded(child: _HunterCard(data: _hunters[1])),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _HunterData {
  const _HunterData(this.name, this.earnings, this.subtitle, this.avatarUrl);
  final String name, earnings, subtitle, avatarUrl;
}

class _HunterCard extends StatelessWidget {
  const _HunterCard({required this.data});
  final _HunterData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(15), width: 0.5),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withAlpha(15),
                backgroundImage: NetworkImage(data.avatarUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(data.name,
                        style: GoogleFonts.poppins(
                          color: BountyColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis),
                    Text(data.subtitle,
                        style: GoogleFonts.poppins(color: Colors.white.withAlpha(70), fontSize: 8, fontWeight: FontWeight.w300)),
                    Text(data.earnings,
                        style: GoogleFonts.poppins(
                          color: BountyColors.neonGreen, fontSize: 11, fontWeight: FontWeight.w600,
                        )),
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

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
//  LOADING OVERLAY
// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BountyColors.mapOverlay,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: BountyColors.neonGreen),
            const SizedBox(height: 16),
            Text('Scanning ghost zone...',
                style: GoogleFonts.poppins(color: BountyColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }}
