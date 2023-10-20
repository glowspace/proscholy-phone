// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_lyrics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songLyricHash() => r'7c360784dcc1701b139f432fc1c9fc805a0f9404';

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

/// See also [songLyric].
@ProviderFor(songLyric)
const songLyricProvider = SongLyricFamily();

/// See also [songLyric].
class SongLyricFamily extends Family<SongLyric?> {
  /// See also [songLyric].
  const SongLyricFamily();

  /// See also [songLyric].
  SongLyricProvider call(
    int id,
  ) {
    return SongLyricProvider(
      id,
    );
  }

  @override
  SongLyricProvider getProviderOverride(
    covariant SongLyricProvider provider,
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
  String? get name => r'songLyricProvider';
}

/// See also [songLyric].
class SongLyricProvider extends AutoDisposeProvider<SongLyric?> {
  /// See also [songLyric].
  SongLyricProvider(
    int id,
  ) : this._internal(
          (ref) => songLyric(
            ref as SongLyricRef,
            id,
          ),
          from: songLyricProvider,
          name: r'songLyricProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songLyricHash,
          dependencies: SongLyricFamily._dependencies,
          allTransitiveDependencies: SongLyricFamily._allTransitiveDependencies,
          id: id,
        );

  SongLyricProvider._internal(
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
    SongLyric? Function(SongLyricRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SongLyricProvider._internal(
        (ref) => create(ref as SongLyricRef),
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
  AutoDisposeProviderElement<SongLyric?> createElement() {
    return _SongLyricProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongLyricProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongLyricRef on AutoDisposeProviderRef<SongLyric?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _SongLyricProviderElement extends AutoDisposeProviderElement<SongLyric?>
    with SongLyricRef {
  _SongLyricProviderElement(super.provider);

  @override
  int get id => (origin as SongLyricProvider).id;
}

String _$songLyricsHash() => r'37e470d124dbe664e775b1dd126c04f72412a070';

/// See also [songLyrics].
@ProviderFor(songLyrics)
final songLyricsProvider = Provider<List<SongLyric>>.internal(
  songLyrics,
  name: r'songLyricsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$songLyricsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SongLyricsRef = ProviderRef<List<SongLyric>>;
String _$songsListSongLyricsHash() =>
    r'5be5b2d1ea1000c78c94c7133639aa835b0eefae';

/// See also [songsListSongLyrics].
@ProviderFor(songsListSongLyrics)
const songsListSongLyricsProvider = SongsListSongLyricsFamily();

/// See also [songsListSongLyrics].
class SongsListSongLyricsFamily extends Family<List<SongLyric>> {
  /// See also [songsListSongLyrics].
  const SongsListSongLyricsFamily();

  /// See also [songsListSongLyrics].
  SongsListSongLyricsProvider call(
    SongsList songsList,
  ) {
    return SongsListSongLyricsProvider(
      songsList,
    );
  }

  @override
  SongsListSongLyricsProvider getProviderOverride(
    covariant SongsListSongLyricsProvider provider,
  ) {
    return call(
      provider.songsList,
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
  String? get name => r'songsListSongLyricsProvider';
}

/// See also [songsListSongLyrics].
class SongsListSongLyricsProvider extends AutoDisposeProvider<List<SongLyric>> {
  /// See also [songsListSongLyrics].
  SongsListSongLyricsProvider(
    SongsList songsList,
  ) : this._internal(
          (ref) => songsListSongLyrics(
            ref as SongsListSongLyricsRef,
            songsList,
          ),
          from: songsListSongLyricsProvider,
          name: r'songsListSongLyricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songsListSongLyricsHash,
          dependencies: SongsListSongLyricsFamily._dependencies,
          allTransitiveDependencies:
              SongsListSongLyricsFamily._allTransitiveDependencies,
          songsList: songsList,
        );

  SongsListSongLyricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.songsList,
  }) : super.internal();

  final SongsList songsList;

  @override
  Override overrideWith(
    List<SongLyric> Function(SongsListSongLyricsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SongsListSongLyricsProvider._internal(
        (ref) => create(ref as SongsListSongLyricsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        songsList: songsList,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<SongLyric>> createElement() {
    return _SongsListSongLyricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongsListSongLyricsProvider && other.songsList == songsList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songsList.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongsListSongLyricsRef on AutoDisposeProviderRef<List<SongLyric>> {
  /// The parameter `songsList` of this provider.
  SongsList get songsList;
}

class _SongsListSongLyricsProviderElement
    extends AutoDisposeProviderElement<List<SongLyric>>
    with SongsListSongLyricsRef {
  _SongsListSongLyricsProviderElement(super.provider);

  @override
  SongsList get songsList => (origin as SongsListSongLyricsProvider).songsList;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
