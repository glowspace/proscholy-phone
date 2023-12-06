import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/constants.dart' hide red, green, blue;
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/routing/navigator_observer.dart';

extension PlatformExtension on TargetPlatform {
  bool get isAndroid => this == TargetPlatform.android;
  bool get isIos => this == TargetPlatform.iOS;
}

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;
}

extension AsyncSnapshotExtension on AsyncSnapshot {
  bool get isDone => connectionState == ConnectionState.done;
}

extension HexColor on Color {
  static Color? fromHex(String? hexColor) {
    if (hexColor == null) return null;

    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) hexColor = "FF$hexColor";

    return Color(int.parse(hexColor, radix: 16));
  }

  String get hex {
    return '#${red.toRadixString(16)}${green.toRadixString(16)}${blue.toRadixString(16)}';
  }
}

extension MediaQueryExtension on MediaQueryData {
  bool get isTablet => size.width > kTabletSizeBreakpoint && size.height > kTabletSizeBreakpoint;
}

extension BuildContextExtension on BuildContext {
  bool get isHome => ModalRoute.of(this)?.settings.name == '/';
  bool get isDisplay => ModalRoute.of(this)?.settings.name == '/display';
  bool get isPlaylist => ModalRoute.of(this)?.settings.name == '/playlist';
  bool get isPlaylists => ModalRoute.of(this)?.settings.name == '/playlists';
  bool get isSearching => ModalRoute.of(this)?.settings.name == '/search';
  bool get isSongbook => ModalRoute.of(this)?.settings.name == '/songbook';

  ProviderContainer get providers => ProviderScope.containerOf(this, listen: false);

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) async {
    // TODO: support better way to redirect
    final uri = Uri.parse(routeName);

    if (uri.queryParameters.containsKey('stitky')) {
      final selectedTags = uri.queryParameters['stitky']!
          .split(',')
          .map((id) => providers.read(tagProvider(int.parse(id))))
          .where((tag) => tag != null)
          .cast<Tag>()
          .toList();

      providers.read(selectedTagsProvider.notifier).push(initialTags: selectedTags);

      routeName = '/search';
    }

    if (providers.read(appNavigatorObserverProvider).isPathInStack(routeName)) {
      popUntil(routeName);

      if (arguments != null) return replace(routeName, arguments: arguments);
    }

    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  void popUntil(String routeName) {
    Navigator.of(this).popUntil((route) => route.settings.name == routeName);
  }

  Future<T?> popAndPush<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).popAndPushNamed(routeName, arguments: arguments);
  }

  void maybePop<T>([T? result]) {
    Navigator.of(this).maybePop(result);
  }

  Future<T?> replace<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }
}
