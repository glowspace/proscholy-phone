// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritePlaylistHash() => r'e489a6e7488d1c65771aecfaaf731228a14c4608';

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
String _$playlistsHash() => r'849bce96671c9ad98f5af1a14ee20e66b1f5d874';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
