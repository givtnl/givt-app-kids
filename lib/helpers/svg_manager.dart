import 'package:flutter_svg/flutter_svg.dart';

class SvgAssetLoaderManager {
  final Map<String, SvgAssetLoader> _loaders = {};

  SvgAssetLoader getLoader(String pictureUrl) {
    if (_loaders.containsKey(pictureUrl)) {
      return _loaders[pictureUrl]!;
    } else {
      final loader = SvgAssetLoader(pictureUrl);
      _loaders[pictureUrl] = loader;
      return loader;
    }
  }

  Future<void> preloadSvgAssets(List<String> pictureUrls) async {
    for (final url in pictureUrls) {
      final loader = getLoader(url);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  SvgPicture buildSvgPicture(String pictureUrl) {
    final loader = getLoader(pictureUrl);
    return SvgPicture.network(loader.assetName);
  }
}