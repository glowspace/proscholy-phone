import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/routing/navigator_observer.dart';
import 'package:zpevnik/routing/router.dart';

void onDestinationSelected(BuildContext context, WidgetRef ref, int index) {
  if (index == 1) {
    if (ref.read(appNavigatorObserverProvider).isSearchRouteInStack) {
      context.popUntil('/search');
    } else {
      context.push('/search');
    }
  } else if (index == 2) {
    if (ref.read(appNavigatorObserverProvider).isPlaylistsRouteInStack) {
      context.popUntil('/playlists');
    } else {
      context.push('/playlists');
    }
  } else {
    context.popUntil('/');
  }
}
