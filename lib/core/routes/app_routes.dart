/// Named route path constants.
/// All routing logic references this class — never hardcode path strings.
abstract final class AppRoutes {
  /// Main unified map screen (Poster mode by default).
  static const String map = '/map';

  /// Hunter overlay — accessed programmatically within the map.
  static const String hunter = '/map/hunter';

  /// Errands dashboard — active & history tabs.
  static const String errands = '/errands';

  /// Wallet — balance & transactions.
  static const String wallet = '/wallet';

  /// Authentication — login / register flow.
  static const String login = '/login';

  /// Registration sub-route.
  static const String register = '/login/register';
}
