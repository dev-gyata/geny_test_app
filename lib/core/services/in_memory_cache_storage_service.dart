import 'package:geny_test_app/core/interceptors/cache_interceptor.dart';

class InMemoryCacheStorageService implements CacheStorage {
  final Map<String, CacheEntry> _cache = {};

  @override
  Future<void> add(String key, CacheEntry value) async {
    _cache[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _cache.remove(key);
  }

  @override
  Future<CacheEntry?> get(String key) async {
    return _cache[key];
  }

  @override
  Future<bool> exists(String key) async {
    return _cache.containsKey(key);
  }

  @override
  Future<void> clearCache() async {
    _cache.clear();
  }
}
