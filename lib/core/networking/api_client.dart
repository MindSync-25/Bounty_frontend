import 'package:dio/dio.dart';
import '../config.dart';

/// [ApiClient] — Configured Dio instance for Phase 2 REST communication.
///
/// PHASE 1: Not used. [AppConfig.useMock] = true routes all calls through mock services.
/// PHASE 2: Inject via GetIt. Add interceptors for:
///   - JWT Bearer token injection ([AuthInterceptor])
///   - Global error normalization ([ErrorInterceptor])
///   - Request/response logging in debug builds ([LogInterceptor])
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _addInterceptors();
  }

  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  void _addInterceptors() {
    _dio.interceptors.addAll([
      // Phase 2: Uncomment and implement
      // AuthInterceptor(),
      // ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        logPrint: (obj) {
          // Replace with your logger in production
          // ignore: avoid_print
          print('[ApiClient] $obj');
        },
      ),
    ]);
  }

  // ── Convenience Methods ────────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
  }) =>
      _dio.delete<T>(path, options: options);
}
