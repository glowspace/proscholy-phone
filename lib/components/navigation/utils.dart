import 'package:flutter/material.dart';
import 'package:zpevnik/routing/navigator_observer.dart';
import 'package:zpevnik/utils/extensions.dart';

void onDestinationSelected(BuildContext context, int index) {
  if (index == 1) {
    if (context.providers.read(appNavigatorObserverProvider).isSearchRouteInStack) {
      context.popUntil('/search');
    } else {
      context.push('/search');
    }
  } else if (index == 2) {
    if (context.providers.read(appNavigatorObserverProvider).isPlaylistsRouteInStack) {
      context.popUntil('/playlists');
    } else {
      context.push('/playlists');
    }
  } else {
    context.popUntil('/');
  }
}
