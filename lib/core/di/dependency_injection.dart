import 'package:get_it/get_it.dart';
import '../networking/api_client.dart';
import '../../data/mock_services/mock_bounty_service.dart';
import '../../data/mock_services/mock_user_service.dart';
import '../../data/mock_services/mock_wallet_service.dart';
import '../../data/mock_services/i_bounty_service.dart';
import '../../data/mock_services/i_user_service.dart';
import '../../data/mock_services/i_wallet_service.dart';
import '../config.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// [DependencyInjection.init] — Called once in [main] before [runApp].
///
/// PHASE 1: Registers mock implementations behind service interfaces.
/// PHASE 2: Swap [MockBountyService] → [RemoteBountyService] etc.
///          The BLoC / UseCases stay identical — only the registered impl changes.
class DependencyInjection {
  DependencyInjection._();

  static Future<void> init() async {
    // ── Infrastructure ───────────────────────────────────────────────────────
    sl.registerLazySingleton<ApiClient>(() => ApiClient.instance);

    if (AppConfig.useMock) {
      _registerMockServices();
    } else {
      _registerRemoteServices();
    }
  }

  // ─── Phase 1: Mock Services ──────────────────────────────────────────────
  static void _registerMockServices() {
    sl.registerLazySingleton<IBountyService>(() => MockBountyService());
    sl.registerLazySingleton<IUserService>(() => MockUserService());
    sl.registerLazySingleton<IWalletService>(() => MockWalletService());
  }

  // ─── Phase 2: Remote Services (Spring Boot REST) ─────────────────────────
  static void _registerRemoteServices() {
    // TODO Phase 2: Register concrete REST implementations:
    // sl.registerLazySingleton<IBountyService>(
    //   () => RemoteBountyService(client: sl<ApiClient>()),
    // );
    // sl.registerLazySingleton<IUserService>(
    //   () => RemoteUserService(client: sl<ApiClient>()),
    // );
    // sl.registerLazySingleton<IWalletService>(
    //   () => RemoteWalletService(client: sl<ApiClient>()),
    // );
    throw UnimplementedError(
      'Remote services not yet implemented. Set AppConfig.useMock = true.',
    );
  }
}
