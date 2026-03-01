import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/app_router.dart';
import 'core/theme/bounty_colors.dart';
import 'core/theme/bounty_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  BOUNTY GHOST — ENTRY POINT
//
//  Phase 1: All data flows through mock services (AppConfig.useMock = true).
//           No network calls are made.
//  Phase 2: Flip AppConfig.useMock = false and supply real --dart-define values.
//           The UI, BLoC, and domain layers remain UNCHANGED.
// ─────────────────────────────────────────────────────────────────────────────

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 1. System chrome — immersive dark UI ─────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1117),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ── 2. Dependency injection ───────────────────────────────────────────────
  await DependencyInjection.init();

  // ── 3. Run app ───────────────────────────────────────────────────────────
  runApp(const BountyGhostApp());
}

/// Root application widget.
class BountyGhostApp extends StatelessWidget {
  const BountyGhostApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      // ── Identity ────────────────────────────────────────────────────────
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // ── Theme — Ghost App Dark Design System ─────────────────────────────
      theme: BountyTheme.darkTheme,

      // ── Routing — GoRouter declarative routes ────────────────────────────
      routerConfig: AppRouter.router,
    );

    // On web: render inside a centered phone frame so it looks like mobile.
    // On real devices: render full screen as normal.
    if (kIsWeb) {
      return _MobileWebFrame(child: app);
    }
    return app;
  }
}

/// Wraps the app in a phone-sized frame when running on web.
/// Simulates a 390×844 (iPhone 14 Pro) form factor centered on the browser.
class _MobileWebFrame extends StatelessWidget {
  const _MobileWebFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: AspectRatio(
            aspectRatio: 390 / 844,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430, maxHeight: 932),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Stack(
                  children: [
                    child,
                    // Phone border overlay
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: BountyColors.divider,
                              width: 1.5,
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