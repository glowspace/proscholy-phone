// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchText)
const searchTextProvider = SearchTextProvider._();

final class SearchTextProvider extends $NotifierProvider<SearchText, String> {
  const SearchTextProvider._()
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

String _$searchTextHash() => r'06d1464ddb2f82005d57e4b9f987001295cf096f';

abstract class _$SearchText extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SearchedSongLyrics)
const searchedSongLyricsProvider = SearchedSongLyricsProvider._();

final class SearchedSongLyricsProvider
    extends $NotifierProvider<SearchedSongLyrics, SearchedSongLyricsResult> {
  const SearchedSongLyricsProvider._()
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
    r'f5e99607d3aa4f36201ad673e4ca9a946c6f04c4';

abstract class _$SearchedSongLyrics
    extends $Notifier<SearchedSongLyricsResult> {
  SearchedSongLyricsResult build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<SearchedSongLyricsResult, SearchedSongLyricsResult>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchedSongLyricsResult, SearchedSongLyricsResult>,
        SearchedSongLyricsResult,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
