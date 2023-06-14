// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_lyrics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songLyricsHash() => r'd069c4e48ad2d91fdfa2d02ee653135750623670';

/// See also [songLyrics].
@ProviderFor(songLyrics)
final songLyricsProvider = AutoDisposeProvider<List<SongLyric>>.internal(
  songLyrics,
  name: r'songLyricsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$songLyricsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SongLyricsRef = AutoDisposeProviderRef<List<SongLyric>>;
String _$songsListSongLyricsHash() =>
    r'5be5b2d1ea1000c78c94c7133639aa835b0eefae';

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

typedef SongsListSongLyricsRef = AutoDisposeProviderRef<List<SongLyric>>;

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
    this.songsList,
  ) : super.internal(
          (ref) => songsListSongLyrics(
            ref,
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
        );

  final SongsList songsList;

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
