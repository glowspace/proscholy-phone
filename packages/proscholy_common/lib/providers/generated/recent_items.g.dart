// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recent_items.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentItems)
const recentItemsProvider = RecentItemsProvider._();

final class RecentItemsProvider
    extends $NotifierProvider<RecentItems, List<RecentItem>> {
  const RecentItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recentItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recentItemsHash();

  @$internal
  @override
  RecentItems create() => RecentItems();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RecentItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RecentItem>>(value),
    );
  }
}

String _$recentItemsHash() => r'f41c42bd527e0eb5869ddba62965c5ede44897d2';

abstract class _$RecentItems extends $Notifier<List<RecentItem>> {
  List<RecentItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<RecentItem>, List<RecentItem>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<RecentItem>, List<RecentItem>>,
        List<RecentItem>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(RecentSongLyrics)
const recentSongLyricsProvider = RecentSongLyricsProvider._();

final class RecentSongLyricsProvider
    extends $NotifierProvider<RecentSongLyrics, List<SongLyric>> {
  const RecentSongLyricsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recentSongLyricsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recentSongLyricsHash();

  @$internal
  @override
  RecentSongLyrics create() => RecentSongLyrics();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SongLyric> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SongLyric>>(value),
    );
  }
}

String _$recentSongLyricsHash() => r'3d79c59c446f062b4b608636ef8cb8bdf8f87fef';

abstract class _$RecentSongLyrics extends $Notifier<List<SongLyric>> {
  List<SongLyric> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<SongLyric>, List<SongLyric>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<SongLyric>, List<SongLyric>>,
        List<SongLyric>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
