// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchText)
final searchTextProvider = SearchTextProvider._();

final class SearchTextProvider extends $NotifierProvider<SearchText, String> {
  SearchTextProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchTextProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchTextHash();

  @$internal
  @override
  SearchText create() => SearchText();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchTextHash() => r'96b6c748a31a65dfcba1567c22aea95bbd1c600b';

abstract class _$SearchText extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SearchedSongLyrics)
final searchedSongLyricsProvider = SearchedSongLyricsProvider._();

final class SearchedSongLyricsProvider
    extends $NotifierProvider<SearchedSongLyrics, SearchedSongLyricsResult> {
  SearchedSongLyricsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchedSongLyricsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchedSongLyricsHash();

  @$internal
  @override
  SearchedSongLyrics create() => SearchedSongLyrics();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchedSongLyricsResult value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchedSongLyricsResult>(value),
    );
  }
}

String _$searchedSongLyricsHash() =>
    r'0d46f0ae5a8f8c97d5d371bc5f16caebda36880e';

abstract class _$SearchedSongLyrics
    extends $Notifier<SearchedSongLyricsResult> {
  SearchedSongLyricsResult build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<SearchedSongLyricsResult, SearchedSongLyricsResult>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchedSongLyricsResult, SearchedSongLyricsResult>,
        SearchedSongLyricsResult,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
