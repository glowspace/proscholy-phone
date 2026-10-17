import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void launch(String url) async {
  final mode = Platform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault;

  try {
    await launchUrl(Uri.parse(url), mode: mode);
  } on PlatformException {
    // there might be no app that can open the link or in-app browser on iOS failed to load it
  }
}
