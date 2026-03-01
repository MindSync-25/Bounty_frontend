import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/bounty_colors.dart';
import '../../../../data/mock_services/i_bounty_service.dart';
import '../../data/repositories_impl/errand_repository_impl.dart';
import '../bloc/errands_bloc.dart';
import '../bloc/errands_event.dart';
import '../bloc/errands_state.dart';
import '../widgets/errand_list_tile.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  ACTIVITY PAGE â€” My Posted Bounties (Poster View) + My Hunts (Hunter View)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ErrandsDashboardPage extends StatelessWidget {
  const ErrandsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ErrandsBloc(
        repository: ErrandRepositoryImpl(service: sl<IBountyService>()),
      )..add(const LoadMyErrands(userId: 'mock-current-user')),
      child: const _ErrandsDashboardView(),
    );
  }
}

class _ErrandsDashboardView extends StatelessWidget {
  const _ErrandsDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BountyColors.backgroundDeep,
      body: SafeArea(
        child: Column(
          children: [
            // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: const BoxDecoration(
                color: BountyColors.backgroundCard,
                border: Border(bottom: BorderSide(color: BountyColors.divider, width: 0.5)),
              ),
              child: Text(
                'BOUNTY',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: BountyColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
            ),
            // â”€â”€ Tab view â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // Tab bar
                    Container(
                      color: BountyColors.backgroundCard,
                      child: TabBar(
                        indicatorColor: BountyColors.neonGreen,
                        indicatorWeight: 2,
                        labelColor: BountyColors.neonGreen,
                        unselectedLabelColor: BountyColors.textDisabled,
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1,
                        ),
                        tabs: const [
                          Tab(text: 'POSTER VIEW'),
                          Tab(text: 'HUNTER VIEW'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<ErrandsBloc, ErrandsState>(
                        builder: (context, state) {
                          if (state is ErrandsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: BountyColors.neonGreen),
                            );
                          }
                          if (state is ErrandsError) {
                            return Center(
                              child: Text(state.message,
                                  style: GoogleFonts.poppins(color: BountyColors.neonRed)),
                            );
                          }
                          if (state is ErrandsLoaded) {
                            return TabBarView(
                              children: [
                                // â”€â”€ POSTER VIEW â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                                _ActivityList(
                                  items: state.postedBounties,
                                  isPoster: true,
                                  emptyIcon: Icons.add_circle_outline,
                                  emptyLabel: 'No bounties posted yet',
                                  emptySub: 'Tap ðŸ‘» on the map to post your first bounty',
                                  emptyColor: BountyColors.neonCyan,
                                ),
                                // â”€â”€ HUNTER VIEW â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                                _ActivityList(
                                  items: state.acceptedBounties,
                                  isPoster: false,
                                  emptyIcon: Icons.sports_esports_outlined,
                                  emptyLabel: 'Not hunting any bounties',
                                  emptySub: 'Switch to Hunter mode on the map to accept bounties',
                                  emptyColor: BountyColors.neonGreen,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({
    required this.items,
    required this.isPoster,
    required this.emptyIcon,
    required this.emptyLabel,
    required this.emptySub,
    required this.emptyColor,
  });

  final List items;
  final bool isPoster;
  final IconData emptyIcon;
  final String emptyLabel, emptySub;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(emptyIcon, color: emptyColor.withAlpha(100), size: 52),
              const SizedBox(height: 16),
              Text(emptyLabel,
                  style: GoogleFonts.poppins(
                    color: BountyColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 6),
              Text(emptySub,
                  style: GoogleFonts.poppins(color: BountyColors.textDisabled, fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ErrandListTile(bounty: items[i], isPoster: isPoster),
    );
  }
}
