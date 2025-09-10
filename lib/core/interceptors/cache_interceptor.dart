import 'package:dio/dio.dart';
import 'package:geny_test_app/core/config/constants.dart';

class CacheEntry {
  CacheEntry(this.response) : createdAt = DateTime.now();
  final DateTime createdAt;
  final Response<dynamic> response;
}

abstract class CacheStorage {
  Future<void> add(String key, CacheEntry value);

  Future<void> remove(String key);

  Future<CacheEntry?> get(String key);

  Future<bool> exists(String key);

  Future<void> clearCache();
}

class CacheInterceptor extends Interceptor {
  CacheInterceptor({
    required CacheStorage cacheStorage,
    Duration? maxAge,
  }) : _cacheStorage = cacheStorage,
       _maxAge = maxAge ?? AppConstants.cacheMaxAge;

  final CacheStorage _cacheStorage;

  final Duration _maxAge;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final cacheKey = options.uri;
    if (options.method.toUpperCase() == 'GET' &&
        await _cacheStorage.exists(cacheKey.toString())) {
      final entry = await _cacheStorage.get(cacheKey.toString());
      final isExpired = DateTime.now().difference(entry!.createdAt) > _maxAge;

      if (!isExpired) {
        return handler.resolve(entry.response);
      } else {
        await _cacheStorage.remove(cacheKey.toString());
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.method.toUpperCase() == 'GET') {
      _cacheStorage.add(
        response.requestOptions.uri.toString(),
        CacheEntry(response),
      );
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final cacheKey = err.requestOptions.uri.toString();
    if (await _cacheStorage.exists(cacheKey)) {
      return handler.resolve((await _cacheStorage.get(cacheKey))!.response);
    }
    handler.next(err);
  }

  Future<void> addToCache(CacheEntry entry) async {
    return _cacheStorage.add(
      entry.response.requestOptions.uri.toString(),
      entry,
    );
  }

  Future<void> clearCache() async {
    return _cacheStorage.clearCache();
  }
}
