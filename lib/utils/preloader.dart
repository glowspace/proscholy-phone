import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

// todo: does not seem to be working yet
class Preloader {
  static Map<String, AssetImage> _preloadedImages = {};

  static void preloadImages(BuildContext context) {
    precacheImage(const AssetImage('$imagesPath/background.png'), context);
    precacheImage(const AssetImage('$imagesPath/background_dark.png'), context);
    precacheImage(const AssetImage('$imagesPath/title.png'), context);
    precacheImage(const AssetImage('$imagesPath/title_dark.png'), context);

    _preloadedImages['1ch'] = const AssetImage('$imagesPath/songbooks/1ch.png');
    _preloadedImages['2ch'] = const AssetImage('$imagesPath/songbooks/2ch.png');
    _preloadedImages['3ch'] = const AssetImage('$imagesPath/songbooks/3ch.png');
    _preloadedImages['4ch'] = const AssetImage('$imagesPath/songbooks/4ch.png');
    _preloadedImages['5ch'] = const AssetImage('$imagesPath/songbooks/5ch.png');
    _preloadedImages['6ch'] = const AssetImage('$imagesPath/songbooks/6ch.png');
    _preloadedImages['7ch'] = const AssetImage('$imagesPath/songbooks/7ch.png');
    _preloadedImages['8ch'] = const AssetImage('$imagesPath/songbooks/8ch.png');
    _preloadedImages['9ch'] = const AssetImage('$imagesPath/songbooks/9ch.png');
    _preloadedImages['c'] = const AssetImage('$imagesPath/songbooks/c.png');
    _preloadedImages['csach'] = const AssetImage('$imagesPath/songbooks/csach.png');
    _preloadedImages['csatr'] = const AssetImage('$imagesPath/songbooks/csatr.png');
    _preloadedImages['csmom'] = const AssetImage('$imagesPath/songbooks/csmom.png');
    _preloadedImages['csmta'] = const AssetImage('$imagesPath/songbooks/csmta.png');
    _preloadedImages['csmzd'] = const AssetImage('$imagesPath/songbooks/csmzd.png');
    _preloadedImages['dbl'] = const AssetImage('$imagesPath/songbooks/dbl.png');
    _preloadedImages['k'] = const AssetImage('$imagesPath/songbooks/k.png');
    _preloadedImages['kan'] = const AssetImage('$imagesPath/songbooks/kan.png');
    _preloadedImages['sdmkr'] = const AssetImage('$imagesPath/songbooks/sdmkr.png');

    _preloadedImages['default'] = const AssetImage('$imagesPath/songbooks/default.png');

    for (final image in _preloadedImages.values) precacheImage(image, context);
  }

  static AssetImage songbookLogo(String shortcut) => _preloadedImages[shortcut] ?? _preloadedImages['default'];
}
