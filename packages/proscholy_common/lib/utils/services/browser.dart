import 'package:flutter/services.dart';

// android only, the app handles links to its website, so it must choose browser explicitly to open them
class BrowserService {
  final methodChannel = const MethodChannel('proscholyCommon/browser');

  const BrowserService._();

  static BrowserService instance = const BrowserService._();

  // returns false when there is no browser that supports custom tabs
  Future<bool> openInCustomTab(Uri uri) async {
    return await methodChannel.invokeMethod<bool>('openInCustomTab', uri.toString()) ?? false;
  }
}
