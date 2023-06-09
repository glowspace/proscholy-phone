import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/utils/extensions.dart';

void launch(BuildContext context, String url) {
  final platform = Theme.of(context).platform;
  final mode = platform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault;

  launchUrl(Uri.parse(url), mode: mode);
}
