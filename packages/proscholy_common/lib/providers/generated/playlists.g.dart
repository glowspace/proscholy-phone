// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playlist)
const playlistProvider = PlaylistFamily._();

final class PlaylistProvider
    extends $FunctionalProvider<Playlist?, Playlist?, Playlist?>
    with $Provider<Playlist?> {
  const PlaylistProvider._(
      {required PlaylistFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'playlistProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$playlistHash();

  @override
  String toString() {
    return r'playlistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Playlist?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Playlist? create(Ref ref) {
    final argument = this.argument as int;
    return playlist(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Playlist? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Playlist?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistHash() => r'0e19b9c0f0b1e05dc464265228ade9d17786531d';

final class PlaylistFamily extends $Family
    with $FunctionalFamilyOverride<Playlist?, int> {
  const PlaylistFamily._()
      : super(
          retry: null,
          name: r'playlistProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PlaylistProvider call(
    int id,
  ) =>
      PlaylistProvider._(argument: id, from: this);

  @override
  String toString() => r'playlistProvider';
}

@ProviderFor(favoritePlaylist)
const favoritePlaylistProvider = FavoritePlaylistProvider._();

final class FavoritePlaylistProvider
    extends $FunctionalProvider<Playlist, Playlist, Playlist>
    with $Provider<Playlist> {
  const FavoritePlaylistProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'favoritePlaylistProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$favoritePlaylistHash();

  @$internal
  @override
  $ProviderElement<Playlist> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Playlist create(Ref ref) {
    return favoritePlaylist(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Playlist value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Playlist>(value),
    );
  }
}

String _$favoritePlaylistHash() => r'9fd754a0465c892225006c5bc0d42cc9c4d8abd2';

@ProviderFor(Playlists)
const playlistsProvider = PlaylistsProvider._();

final class PlaylistsProvider
    extends $NotifierProvider<Playlists, List<Playlist>> {
  const PlaylistsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'playlistsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$playlistsHash();

  @$internal
  @override
  Playlists create() => Playlists();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Playlist> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Playlist>>(value),
    );
  }
}

String _$playlistsHash() => r'532849f323d46598709f11f2a022dfdce2dd3af0';

abstract class _$Playlists extends $Notifier<List<Playlist>> {
  List<Playlist> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Playlist>, List<Playlist>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Playlist>, List<Playlist>>,
        List<Playlist>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
