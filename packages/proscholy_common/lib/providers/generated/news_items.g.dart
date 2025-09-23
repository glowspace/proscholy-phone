// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../news_items.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsItems)
const newsItemsProvider = NewsItemsProvider._();

final class NewsItemsProvider
    extends $FunctionalProvider<List<NewsItem>, List<NewsItem>, List<NewsItem>>
    with $Provider<List<NewsItem>> {
  const NewsItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newsItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newsItemsHash();

  @$internal
  @override
  $ProviderElement<List<NewsItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<NewsItem> create(Ref ref) {
    return newsItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NewsItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NewsItem>>(value),
    );
  }
}

String _$newsItemsHash() => r'0470596684bab5ed9daeda3553dcf366e4e3aacb';
