// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_lyrics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songLyricsHash() => r'3fd6d38283929d11d0aa3e6da91d224335044034';

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
String _$filteredSongLyricsHash() =>
    r'1b17747dbe67c621e42c542fcb3ec8b8af5f5681';

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

typedef FilteredSongLyricsRef = AutoDisposeProviderRef<List<SongLyric>>;

/// See also [filteredSongLyrics].
@ProviderFor(filteredSongLyrics)
const filteredSongLyricsProvider = FilteredSongLyricsFamily();

/// See also [filteredSongLyrics].
class FilteredSongLyricsFamily extends Family<List<SongLyric>> {
  /// See also [filteredSongLyrics].
  const FilteredSongLyricsFamily();

  /// See also [filteredSongLyrics].
  FilteredSongLyricsProvider call(
    List<SongLyric> songLyrics,
  ) {
    return FilteredSongLyricsProvider(
      songLyrics,
    );
  }

  @override
  FilteredSongLyricsProvider getProviderOverride(
    covariant FilteredSongLyricsProvider provider,
  ) {
    return call(
      provider.songLyrics,
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
  String? get name => r'filteredSongLyricsProvider';
}

/// See also [filteredSongLyrics].
class FilteredSongLyricsProvider extends AutoDisposeProvider<List<SongLyric>> {
  /// See also [filteredSongLyrics].
  FilteredSongLyricsProvider(
    this.songLyrics,
  ) : super.internal(
          (ref) => filteredSongLyrics(
            ref,
            songLyrics,
          ),
          from: filteredSongLyricsProvider,
          name: r'filteredSongLyricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredSongLyricsHash,
          dependencies: FilteredSongLyricsFamily._dependencies,
          allTransitiveDependencies:
              FilteredSongLyricsFamily._allTransitiveDependencies,
        );

  final List<SongLyric> songLyrics;

  @override
  bool operator ==(Object other) {
    return other is FilteredSongLyricsProvider &&
        other.songLyrics == songLyrics;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songLyrics.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$songsListSongLyricsHash() =>
    r'5be5b2d1ea1000c78c94c7133639aa835b0eefae';
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

String _$recentSongLyricsHash() => r'76f10d9ea4ca1ed503692dfbd0a2e3023e796307';

/// See also [RecentSongLyrics].
@ProviderFor(RecentSongLyrics)
final recentSongLyricsProvider =
    AutoDisposeNotifierProvider<RecentSongLyrics, List<SongLyric>>.internal(
  RecentSongLyrics.new,
  name: r'recentSongLyricsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentSongLyricsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentSongLyrics = AutoDisposeNotifier<List<SongLyric>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
