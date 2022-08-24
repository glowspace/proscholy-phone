import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

void launch(String url) {
  final LaunchMode mode;

  if (Platform.isAndroid) {
    mode = LaunchMode.externalApplication;
  } else {
    mode = LaunchMode.platformDefault;
  }

  launchUrl(Uri.parse(url), mode: mode);
}
