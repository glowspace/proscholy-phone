import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

void launch(String url) {
  final mode = Platform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault;

  launchUrl(Uri.parse(url), mode: mode);
}
