// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../song_lyrics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(songLyric)
const songLyricProvider = SongLyricFamily._();

final class SongLyricProvider
    extends $FunctionalProvider<SongLyric?, SongLyric?, SongLyric?>
    with $Provider<SongLyric?> {
  const SongLyricProvider._(
      {required SongLyricFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'songLyricProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$songLyricHash();

  @override
  String toString() {
    return r'songLyricProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SongLyric?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SongLyric? create(Ref ref) {
    final argument = this.argument as int;
    return songLyric(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SongLyric? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SongLyric?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SongLyricProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songLyricHash() => r'f0c87289772047b9bd148c8929f6f1e95a630e74';

final class SongLyricFamily extends $Family
    with $FunctionalFamilyOverride<SongLyric?, int> {
  const SongLyricFamily._()
      : super(
          retry: null,
          name: r'songLyricProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SongLyricProvider call(
    int id,
  ) =>
      SongLyricProvider._(argument: id, from: this);

  @override
  String toString() => r'songLyricProvider';
}

@ProviderFor(songLyrics)
const songLyricsProvider = SongLyricsProvider._();

final class SongLyricsProvider extends $FunctionalProvider<List<SongLyric>,
    List<SongLyric>, List<SongLyric>> with $Provider<List<SongLyric>> {
  const SongLyricsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'songLyricsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$songLyricsHash();

  @$internal
  @override
  $ProviderElement<List<SongLyric>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SongLyric> create(Ref ref) {
    return songLyrics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SongLyric> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SongLyric>>(value),
    );
  }
}

String _$songLyricsHash() => r'f315b02e2aaaed18d27f54f17de7f699e6223d25';

@ProviderFor(songsListSongLyrics)
const songsListSongLyricsProvider = SongsListSongLyricsFamily._();

final class SongsListSongLyricsProvider extends $FunctionalProvider<
    List<SongLyric>,
    List<SongLyric>,
    List<SongLyric>> with $Provider<List<SongLyric>> {
  const SongsListSongLyricsProvider._(
      {required SongsListSongLyricsFamily super.from,
      required SongsList super.argument})
      : super(
          retry: null,
          name: r'songsListSongLyricsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$songsListSongLyricsHash();

  @override
  String toString() {
    return r'songsListSongLyricsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<SongLyric>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SongLyric> create(Ref ref) {
    final argument = this.argument as SongsList;
    return songsListSongLyrics(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SongLyric> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SongLyric>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SongsListSongLyricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songsListSongLyricsHash() =>
    r'f7453854225630fcd3b1ab2d8c093243f7985c9d';

final class SongsListSongLyricsFamily extends $Family
    with $FunctionalFamilyOverride<List<SongLyric>, SongsList> {
  const SongsListSongLyricsFamily._()
      : super(
          retry: null,
          name: r'songsListSongLyricsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SongsListSongLyricsProvider call(
    SongsList songsList,
  ) =>
      SongsListSongLyricsProvider._(argument: songsList, from: this);

  @override
  String toString() => r'songsListSongLyricsProvider';
}
