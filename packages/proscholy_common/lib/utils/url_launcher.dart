import 'dart:io';

import 'package:flutter/services.dart';
import 'package:proscholy_common/links.dart';
import 'package:proscholy_common/utils/services/browser.dart';
import 'package:url_launcher/url_launcher.dart';

void launch(String url) async {
  final uri = Uri.parse(url);
  final mode = Platform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault;

  try {
    // android would open links to the website in the app again
    if (Platform.isAndroid && uri.host == baseUrl && await BrowserService.instance.openInCustomTab(uri)) return;

    await launchUrl(uri, mode: mode);
  } on PlatformException {
    // there might be no app that can open the link or in-app browser on iOS failed to load it
  }
}
