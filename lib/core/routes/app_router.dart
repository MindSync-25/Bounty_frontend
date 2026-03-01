import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shell/bounty_shell.dart';
import '../routes/app_routes.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/map_poster/presentation/pages/unified_map_page.dart';
import '../../features/errands_dashboard/presentation/pages/errands_dashboard_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';

/// [AppRouter] — Single source of truth for all app navigation.
///
/// Uses GoRouter with a [ShellRoute] to keep [BountyShell] (bottom nav)
/// persistent across the Map, Errands, and Wallet tabs.
///
/// Phase 2: Add redirect guards using [GoRouter.redirect] for auth state.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.map,
    debugLogDiagnostics: true,

    // ── Phase 2: Auth Guard ──────────────────────────────────────────────────
    // redirect: (context, state) {
    //   final isAuthenticated = sl<AuthBloc>().state is AuthAuthenticated;
    //   final isOnLogin = state.matchedLocation == AppRoutes.login;
    //   if (!isAuthenticated && !isOnLogin) return AppRoutes.login;
    //   if (isAuthenticated && isOnLogin) return AppRoutes.map;
    //   return null;
    // },

    routes: [
      // ── Auth flow (outside shell, no bottom nav) ──────────────────────────
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const LoginPage(),
        ),
      ),

      // ── Main shell with persistent bottom nav ─────────────────────────────
      ShellRoute(
        builder: (context, state, child) => BountyShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.map,
            pageBuilder: (context, state) => _fadeTransition(
              state,
              const UnifiedMapPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.errands,
            pageBuilder: (context, state) => _fadeTransition(
              state,
              const ErrandsDashboardPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.wallet,
            pageBuilder: (context, state) => _fadeTransition(
              state,
              const WalletPage(),
            ),
          ),
        ],
      ),
    ],

    // ── Error page ───────────────────────────────────────────────────────────
    errorBuilder: (context, state) => _RouteErrorPage(error: state.error),
  );

  static CustomTransitionPage<void> _fadeTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '404 — Route not found\n${error?.toString() ?? ''}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
