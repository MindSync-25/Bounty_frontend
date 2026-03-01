/// [AppConfig] — Single source of truth for environment-level settings.
///
/// PHASE 1 (current): [useMock] = true → all data comes from [MockBountyService],
///   [MockUserService], [MockWalletService]. Zero network calls.
///
/// PHASE 2: Set [useMock] = false and supply real values via --dart-define:
///   flutter run \
///     --dart-define=BASE_URL=https://api.bountyghost.com/api/v1 \
///     --dart-define=WS_URL=wss://api.bountyghost.com/ws \
///     --dart-define=GOOGLE_MAPS_KEY=AIza...
///
/// DO NOT commit real secrets. Use CI/CD secret injection for --dart-define values.

class AppConfig {
  AppConfig._();

  // ── Identity ───────────────────────────────────────────────────────────────
  static const String appName = 'Bounty Ghost';
  static const String appVersion = '1.0.0';

  // ── Phase Toggle ──────────────────────────────────────────────────────────
  /// Flip to [false] in Phase 2 to route through real Spring Boot services.
  static const bool useMock = true;

  // ── Spring Boot REST Base URL ─────────────────────────────────────────────
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  // ── Spring STOMP WebSocket URL ────────────────────────────────────────────
  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'ws://localhost:8080/ws',
  );

  // ── Google Maps API Key ───────────────────────────────────────────────────
  /// Also add to android/app/src/main/AndroidManifest.xml &
  ///           ios/Runner/AppDelegate.swift (GMSServices.provideAPIKey)
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_KEY',
    defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY_HERE',
  );

  // ── HTTP Timeouts ──────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 15);

  // ── Mock Data Config ───────────────────────────────────────────────────────
  /// Simulated network latency in Phase 1
  static const Duration mockLatency = Duration(milliseconds: 400);

  /// Default radius for nearby bounty queries (km)
  static const double defaultSearchRadiusKm = 5.0;
}
