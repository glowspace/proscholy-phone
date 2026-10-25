// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlaylistNotifier)
final playlistProvider = PlaylistNotifierFamily._();

final class PlaylistNotifierProvider
    extends $NotifierProvider<PlaylistNotifier, Playlist?> {
  PlaylistNotifierProvider._({
    required PlaylistNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'playlistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistNotifierHash();

  @override
  String toString() {
    return r'playlistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlaylistNotifier create() => PlaylistNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Playlist? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Playlist?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistNotifierHash() => r'8918c6b85d3bedc7f0b14f0ed45f0d06eebebc78';

final class PlaylistNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PlaylistNotifier,
          Playlist?,
          Playlist?,
          Playlist?,
          int
        > {
  PlaylistNotifierFamily._()
    : super(
        retry: null,
        name: r'playlistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaylistNotifierProvider call(int id) =>
      PlaylistNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'playlistProvider';
}

abstract class _$PlaylistNotifier extends $Notifier<Playlist?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Playlist? build(int id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Playlist?, Playlist?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Playlist?, Playlist?>,
              Playlist?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(favoritePlaylist)
final favoritePlaylistProvider = FavoritePlaylistProvider._();

final class FavoritePlaylistProvider
    extends $FunctionalProvider<Playlist, Playlist, Playlist>
    with $Provider<Playlist> {
  FavoritePlaylistProvider._()
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

String _$favoritePlaylistHash() => r'dfe94b6c75bb3cfd09516fac9736fdf0af014456';

@ProviderFor(Playlists)
final playlistsProvider = PlaylistsProvider._();

final class PlaylistsProvider
    extends $NotifierProvider<Playlists, List<Playlist>> {
  PlaylistsProvider._()
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

String _$playlistsHash() => r'c23763118d9ab82b359163012f4eaa13e62a9bcd';

abstract class _$Playlists extends $Notifier<List<Playlist>> {
  List<Playlist> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Playlist>, List<Playlist>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Playlist>, List<Playlist>>,
              List<Playlist>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
