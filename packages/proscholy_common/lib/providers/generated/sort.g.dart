// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sort.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Sort)
const sortProvider = SortProvider._();

final class SortProvider extends $NotifierProvider<Sort, SortType> {
  const SortProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sortProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sortHash();

  @$internal
  @override
  Sort create() => Sort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortType>(value),
    );
  }
}

String _$sortHash() => r'd36b9b8948691e96f8fe6e125069284432701592';

abstract class _$Sort extends $Notifier<SortType> {
  SortType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SortType, SortType>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SortType, SortType>, SortType, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
