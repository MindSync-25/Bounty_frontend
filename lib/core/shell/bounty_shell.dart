import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/bounty_colors.dart';
import '../routes/app_routes.dart';

/// [BountyShell] — Persistent navigation shell for the three main tabs:
///  MAP (ghost map) · ACTIVITY (errands) · WALLET (balance + history)
class BountyShell extends StatelessWidget {
  const BountyShell({required this.child, super.key});

  final Widget child;

  static const List<_NavItem> _items = [
    _NavItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'MAP',
      path: AppRoutes.map,
    ),
    _NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'ACTIVITY',
      path: AppRoutes.errands,
    ),
    _NavItem(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      label: 'WALLET',
      path: AppRoutes.wallet,
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.errands)) return 1;
    if (location.startsWith(AppRoutes.wallet)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      backgroundColor: BountyColors.backgroundDeep,
      body: child,
      bottomNavigationBar: _GhostNavBar(
        currentIndex: currentIndex,
        items: _items,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.map);
            case 1:
              context.go(AppRoutes.errands);
            case 2:
              context.go(AppRoutes.wallet);
          }
        },
      ),
    );
  }
}

class _GhostNavBar extends StatelessWidget {
  const _GhostNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(160),
            border: Border(top: BorderSide(color: Colors.white.withAlpha(18), width: 0.5)),
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: i == currentIndex
                                ? BountyColors.neonGreen.withAlpha(20)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            i == currentIndex ? items[i].activeIcon : items[i].icon,
                            color: i == currentIndex
                                ? BountyColors.neonGreen
                                : Colors.white.withAlpha(60),
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].label,
                          style: GoogleFonts.poppins(
                            color: i == currentIndex
                                ? BountyColors.neonGreen
                                : Colors.white.withAlpha(50),
                            fontSize: 8,
                            fontWeight: i == currentIndex
                                ? FontWeight.w600
                                : FontWeight.w400,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
}



