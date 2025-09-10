import 'package:dio/dio.dart';
import 'package:geny_test_app/core/config/constants.dart';

class CacheEntry {
  CacheEntry(this.response) : createdAt = DateTime.now();
  final DateTime createdAt;
  final Response<dynamic> response;
}

class CacheInterceptor extends Interceptor {
  CacheInterceptor({Duration? maxAge})
    : _maxAge = maxAge ?? AppConstants.cacheMaxAge;

  final Map<String, CacheEntry> _cache = {};
  final Duration _maxAge;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cacheKey = options.uri;
    if (options.method.toUpperCase() == 'GET' &&
        _cache.containsKey(cacheKey.toString())) {
      final entry = _cache[cacheKey.toString()]!;
      final isExpired = DateTime.now().difference(entry.createdAt) > _maxAge;

      if (!isExpired) {
        return handler.resolve(entry.response);
      } else {
        _cache.remove(cacheKey.toString());
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
      _cache[response.requestOptions.uri.toString()] = CacheEntry(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final cacheKey = err.requestOptions.uri.toString();
    if (_cache.containsKey(cacheKey)) {
      return handler.resolve(_cache[cacheKey]!.response);
    }
    handler.next(err);
  }

  void addToCache(CacheEntry entry) {
    _cache[entry.response.requestOptions.uri.toString()] = entry;
  }

  void clearCache() {
    _cache.clear();
  }
}
