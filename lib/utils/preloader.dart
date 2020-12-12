import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class Preloader {
  static MemoryImage _background, _backgroundDark;
  static MemoryImage _title, _titleDark;

  static MemoryImage get background => _background;
  static MemoryImage get backgroundDark => _backgroundDark;
  static MemoryImage get title => _title;
  static MemoryImage get titleDark => _titleDark;

  static Future<void> preloadImages() async {
    _background = MemoryImage(await _loadImage('$imagesPath/background.png'));
    _backgroundDark = MemoryImage(await _loadImage('$imagesPath/background_dark.png'));
    _title = MemoryImage(await _loadImage('$imagesPath/title.png'));
    _titleDark = MemoryImage(await _loadImage('$imagesPath/title_dark.png'));
  }

  static Future<Uint8List> _loadImage(String url) {
    ImageStreamListener listener;

    final Completer<Uint8List> completer = Completer<Uint8List>();
    final ImageStream imageStream = AssetImage(url).resolve(ImageConfiguration.empty);

    listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        imageInfo.image.toByteData(format: ImageByteFormat.png).then((ByteData byteData) {
          imageStream.removeListener(listener);
          completer.complete(byteData.buffer.asUint8List());
        });
      },
      onError: (dynamic exception, StackTrace stackTrace) {
        imageStream.removeListener(listener);
        completer.completeError(exception);
      },
    );

    imageStream.addListener(listener);

    return completer.future;
  }
}
