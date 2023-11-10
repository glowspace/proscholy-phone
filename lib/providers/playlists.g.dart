// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistHash() => r'0e19b9c0f0b1e05dc464265228ade9d17786531d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [playlist].
@ProviderFor(playlist)
const playlistProvider = PlaylistFamily();

/// See also [playlist].
class PlaylistFamily extends Family<Playlist?> {
  /// See also [playlist].
  const PlaylistFamily();

  /// See also [playlist].
  PlaylistProvider call(
    int id,
  ) {
    return PlaylistProvider(
      id,
    );
  }

  @override
  PlaylistProvider getProviderOverride(
    covariant PlaylistProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playlistProvider';
}

/// See also [playlist].
class PlaylistProvider extends AutoDisposeProvider<Playlist?> {
  /// See also [playlist].
  PlaylistProvider(
    int id,
  ) : this._internal(
          (ref) => playlist(
            ref as PlaylistRef,
            id,
          ),
          from: playlistProvider,
          name: r'playlistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playlistHash,
          dependencies: PlaylistFamily._dependencies,
          allTransitiveDependencies: PlaylistFamily._allTransitiveDependencies,
          id: id,
        );

  PlaylistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    Playlist? Function(PlaylistRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaylistProvider._internal(
        (ref) => create(ref as PlaylistRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Playlist?> createElement() {
    return _PlaylistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlaylistRef on AutoDisposeProviderRef<Playlist?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PlaylistProviderElement extends AutoDisposeProviderElement<Playlist?>
    with PlaylistRef {
  _PlaylistProviderElement(super.provider);

  @override
  int get id => (origin as PlaylistProvider).id;
}

String _$favoritePlaylistHash() => r'9fd754a0465c892225006c5bc0d42cc9c4d8abd2';

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
String _$playlistsHash() => r'c8a57318c26e3549d744e3f20228c587006eab77';

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
