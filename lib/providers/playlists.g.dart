// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritePlaylistHash() => r'8eca6b2b20812069eae910fefbd0f8e11933b568';

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
String _$playlistsHash() => r'5b38f593efee830fc3ebb43a3db7976889a12649';

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
