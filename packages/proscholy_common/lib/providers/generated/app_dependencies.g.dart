// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDependencies)
const appDependenciesProvider = AppDependenciesProvider._();

final class AppDependenciesProvider extends $FunctionalProvider<AppDependencies,
    AppDependencies, AppDependencies> with $Provider<AppDependencies> {
  const AppDependenciesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appDependenciesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appDependenciesHash();

  @$internal
  @override
  $ProviderElement<AppDependencies> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDependencies create(Ref ref) {
    return appDependencies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDependencies value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDependencies>(value),
    );
  }
}

String _$appDependenciesHash() => r'0d0e0d4753ad6fb358e9b6658cfa402d68ade6f6';
