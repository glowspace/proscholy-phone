// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigator_observer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appNavigatorObserver)
const appNavigatorObserverProvider = AppNavigatorObserverProvider._();

final class AppNavigatorObserverProvider extends $FunctionalProvider<
    AppNavigatorObserver,
    AppNavigatorObserver,
    AppNavigatorObserver> with $Provider<AppNavigatorObserver> {
  const AppNavigatorObserverProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appNavigatorObserverProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appNavigatorObserverHash();

  @$internal
  @override
  $ProviderElement<AppNavigatorObserver> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppNavigatorObserver create(Ref ref) {
    return appNavigatorObserver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppNavigatorObserver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppNavigatorObserver>(value),
    );
  }
}

String _$appNavigatorObserverHash() =>
    r'e30c3d136f5b21016597ed11c6eb238d58c6acd9';
