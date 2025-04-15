import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

import '../../../config.dart';
import '../../core/utils/path_provider/index.dart';

CacheOptions cacheOptions = CacheOptions(
  store: HiveCacheStore(AppPathProvider.path),
  policy: CachePolicy.noCache,
  hitCacheOnErrorExcept: [],
  maxStale: const Duration(days: Config.cacheDays),
  //increase number of days for logger cache
  priority: CachePriority.high,
);
