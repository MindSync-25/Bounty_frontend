import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/bounty_colors.dart';
import '../../../../data/mock_services/i_wallet_service.dart';
import '../../../../data/mock_services/mock_models/mock_wallet.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../widgets/transaction_tile.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  ACTIVITY & WALLET â€” Unified screen (Screen 3 of Bounty Ghost)
//  Shows: Profile Â· Active Errands Â· Completed Tasks Â· Wallet Balance + History
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc(walletService: sl<IWalletService>())
        ..add(const LoadWallet(userId: 'mock-current-user')),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listenWhen: (_, curr) => curr is WalletActionSuccess || curr is WalletError,
      listener: (context, state) {
        if (state is WalletActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: BountyColors.backgroundCard,
              content: Text(state.message,
                  style: GoogleFonts.poppins(color: BountyColors.textPrimary)),
            ),
          );
        } else if (state is WalletError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: BountyColors.neonRed.withAlpha(200),
            ),
          );
        }
      },
      builder: (context, state) {
        final wallet = switch (state) {
          WalletLoaded(wallet: final w) => w,
          WalletActionSuccess(wallet: final w) => w,
          _ => null,
        };

        return Scaffold(
          backgroundColor: BountyColors.backgroundDeep,
          body: SafeArea(
            child: Column(
              children: [
                // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _PageHeader(wallet: wallet),
                // â”€â”€ Scrollable body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Expanded(
                  child: state is WalletLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: BountyColors.neonGreen),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          children: [
                            const SizedBox(height: 10),
                            // Active Errands
                            const _SectionHeader(
                              title: 'ACTIVE ERRANDS',
                              rightLabel: 'POSTER VIEW',
                              rightColor: BountyColors.neonGreen,
                            ),
                            const SizedBox(height: 8),
                            const _ActiveErrandCard(),
                            const SizedBox(height: 20),
                            // Completed Tasks
                            const _SectionHeader(
                              title: 'COMPLETED TASKS',
                              rightLabel: 'HUNTER VIEW',
                              rightColor: BountyColors.neonCyan,
                            ),
                            const SizedBox(height: 8),
                            const _CompletedTasksList(),
                            const SizedBox(height: 20),
                            // My Wallet
                            const _SectionHeader(
                              title: 'MY WALLET',
                              rightLabel: null,
                            ),
                            const SizedBox(height: 8),
                            if (wallet != null)
                              _WalletCard(wallet: wallet)
                            else
                              const _WalletCardStatic(),
                            const SizedBox(height: 20),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  PAGE HEADER â€” "BOUNTY" title + Profile row
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.wallet});
  final MockWallet? wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: const BoxDecoration(
        color: BountyColors.backgroundCard,
        border: Border(bottom: BorderSide(color: BountyColors.divider, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App title
          Text(
            'BOUNTY',
            style: GoogleFonts.poppins(
              color: BountyColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),
          // Profile row
          Row(
            children: [
              // Avatar with green ring
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: BountyColors.neonGreen, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: BountyColors.backgroundLayer,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                ),
              ),
              const SizedBox(width: 10),
              // Name + trust badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ARJUN K.',
                      style: GoogleFonts.poppins(
                        color: BountyColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: BountyColors.neonGreen.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: BountyColors.neonGreen.withAlpha(80), width: 0.5),
                      ),
                      child: Text(
                        'TRUST SCORE: 98% (LEGEND)',
                        style: GoogleFonts.poppins(
                          color: BountyColors.neonGreen,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Notifications toggle
              Column(
                children: [
                  Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: BountyColors.neonGreen,
                    inactiveTrackColor: BountyColors.backgroundLayer,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text('NOTIFICATIONS',
                      style: GoogleFonts.poppins(
                        color: BountyColors.textDisabled, fontSize: 7, letterSpacing: 0.3,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  SECTION HEADER â€” Title + right label
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.rightLabel,
    this.rightColor = BountyColors.textSecondary,
  });
  final String title;
  final String? rightLabel;
  final Color rightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: BountyColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        if (rightLabel != null)
          Text(
            rightLabel!,
            style: GoogleFonts.poppins(
              color: rightColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  ACTIVE ERRAND CARD â€” Live progress card (POSTER VIEW)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ActiveErrandCard extends StatelessWidget {
  const _ActiveErrandCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BountyColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BountyColors.neonGreen.withAlpha(60), width: 1),
        boxShadow: [
          BoxShadow(
            color: BountyColors.neonGreen.withAlpha(15),
            blurRadius: 12, spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live badge + title row
          Row(
            children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: BountyColors.neonGreen,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'LIVE',
                style: GoogleFonts.poppins(
                  color: BountyColors.neonGreen, fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "RAVI'S DOSA IS COMING!",
            style: GoogleFonts.poppins(
              color: BountyColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '(Rahul is 50m away, ETA 3 mins)',
            style: GoogleFonts.poppins(
              color: BountyColors.textSecondary, fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          // Progress dots
          Row(
            children: List.generate(10, (i) {
              final active = i < 7;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  height: 5,
                  decoration: BoxDecoration(
                    color: active
                        ? BountyColors.neonGreen
                        : BountyColors.backgroundLayer,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  COMPLETED TASKS LIST â€” Hunter earnings (HUNTER VIEW)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CompletedTasksList extends StatelessWidget {
  const _CompletedTasksList();

  static const _tasks = [
    ('Coffee Delivery:', '+\$3'),
    ('Coffee Delivery:', '+\$3'),
    ('Rahul Delivery:', '+\$3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BountyColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BountyColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _tasks.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 0.4, color: BountyColors.divider),
            _TaskRow(label: _tasks[i].$1, reward: _tasks[i].$2),
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.label, required this.reward});
  final String label;
  final String reward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 7, height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, color: BountyColors.neonGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                  color: BountyColors.textPrimary, fontSize: 12,
                  fontWeight: FontWeight.w500,
                )),
          ),
          Text(reward,
              style: GoogleFonts.poppins(
                color: BountyColors.neonGreen, fontSize: 12, fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  WALLET CARD â€” Balance + buttons + transaction history
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.wallet});
  final MockWallet wallet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Balance section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: BountyColors.backgroundCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BountyColors.divider, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AVAILABLE BALANCE:',
                style: GoogleFonts.poppins(
                  color: BountyColors.textSecondary, fontSize: 11,
                  fontWeight: FontWeight.w600, letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                wallet.balanceDisplay,
                style: GoogleFonts.poppins(
                  color: BountyColors.textPrimary, fontSize: 38,
                  fontWeight: FontWeight.w800, height: 1.1,
                ),
              ),
              const SizedBox(height: 14),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<WalletBloc>().add(
                        const DepositFunds(userId: 'mock-current-user', amountCents: 5000),
                      ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: BountyColors.neonGreen.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: BountyColors.neonGreen, width: 1),
                        ),
                        child: Center(
                          child: Text('ADD MONEY',
                              style: GoogleFonts.poppins(
                                color: BountyColors.neonGreen, fontSize: 11,
                                fontWeight: FontWeight.w700, letterSpacing: 0.3,
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<WalletBloc>().add(
                        const WithdrawFunds(userId: 'mock-current-user', amountCents: 2000),
                      ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: BountyColors.backgroundLayer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: BountyColors.divider, width: 1),
                        ),
                        child: Center(
                          child: Text('WITHDRAW EARNINGS',
                              style: GoogleFonts.poppins(
                                color: BountyColors.textSecondary, fontSize: 10,
                                fontWeight: FontWeight.w600, letterSpacing: 0.2,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Transaction list
        Container(
          decoration: BoxDecoration(
            color: BountyColors.backgroundCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BountyColors.divider, width: 0.5),
          ),
          child: wallet.transactions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text('No transactions yet',
                        style: GoogleFonts.poppins(color: BountyColors.textDisabled)),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < wallet.transactions.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, thickness: 0.4, color: BountyColors.divider),
                      _TxRow(transaction: wallet.transactions[i]),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

/// Fallback card when BLoC data not yet loaded
class _WalletCardStatic extends StatelessWidget {
  const _WalletCardStatic();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BountyColors.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BountyColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('AVAILABLE BALANCE:',
              style: GoogleFonts.poppins(
                color: BountyColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Text('\$74.50',
              style: GoogleFonts.poppins(
                color: BountyColors.textPrimary, fontSize: 38, fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 14),
          const _TxStaticList(),
        ],
      ),
    );
  }
}

class _TxStaticList extends StatelessWidget {
  const _TxStaticList();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StaticTxRow(icon: Icons.attach_money, iconColor: BountyColors.neonGreen,
            label: 'Bounty Payment', sub: 'Payment', amount: '+\$74.50', amountColor: BountyColors.neonGreen),
        const Divider(height: 1, thickness: 0.4, color: BountyColors.divider),
        _StaticTxRow(icon: Icons.arrow_upward, iconColor: BountyColors.neonRed,
            label: 'Bounty Payment', sub: 'Fee deducted', amount: '-\$30', amountColor: BountyColors.neonRed),
        const Divider(height: 1, thickness: 0.4, color: BountyColors.divider),
        _StaticTxRow(icon: Icons.close, iconColor: BountyColors.neonRed,
            label: 'Bounty Payment', sub: 'Fee deducted', amount: '-\$20', amountColor: BountyColors.neonRed),
      ],
    );
  }
}

class _StaticTxRow extends StatelessWidget {
  const _StaticTxRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sub,
    required this.amount,
    required this.amountColor,
  });
  final IconData icon;
  final Color iconColor;
  final String label, sub, amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withAlpha(20),
              border: Border.all(color: iconColor.withAlpha(80), width: 0.5),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: GoogleFonts.poppins(
                  color: BountyColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600,
                )),
                Text(sub, style: GoogleFonts.poppins(
                  color: BountyColors.textSecondary, fontSize: 10,
                )),
              ],
            ),
          ),
          Text(amount, style: GoogleFonts.poppins(
            color: amountColor, fontSize: 13, fontWeight: FontWeight.w700,
          )),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  TX ROW â€” Transaction row using BLoC wallet data
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TxRow extends StatelessWidget {
  const _TxRow({required this.transaction});
  final dynamic transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TransactionTile(transaction: transaction),
    );
  }
}
