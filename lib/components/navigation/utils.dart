import 'package:flutter/material.dart';
import 'package:zpevnik/routing/router.dart';

void onDestinationSelected(BuildContext context, int index) {
  if (index == 1) {
    context.push('/search');
  } else if (index == 2) {
    // TODO: should pop if already inside of playlists subtree
    context.push('/playlists');
  } else {
    context.popUntil('/');
  }
}
