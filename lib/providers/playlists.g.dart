// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritePlaylistHash() => r'34a259c8884054b8d3ac012a21bc6e154e28cc42';

/// See also [favoritePlaylist].
@ProviderFor(favoritePlaylist)
final favoritePlaylistProvider = Provider<Playlist>.internal(
  favoritePlaylist,
  name: r'favoritePlaylistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritePlaylistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoritePlaylistRef = ProviderRef<Playlist>;
String _$playlistsHash() => r'c9698e175a923301d1a909c1096764595bfe5bff';

/// See also [Playlists].
@ProviderFor(Playlists)
final playlistsProvider = NotifierProvider<Playlists, List<Playlist>>.internal(
  Playlists.new,
  name: r'playlistsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playlistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Playlists = Notifier<List<Playlist>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
