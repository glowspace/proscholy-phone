// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../menu_collapsed.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MenuCollapsed)
const menuCollapsedProvider = MenuCollapsedProvider._();

final class MenuCollapsedProvider
    extends $NotifierProvider<MenuCollapsed, bool> {
  const MenuCollapsedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'menuCollapsedProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$menuCollapsedHash();

  @$internal
  @override
  MenuCollapsed create() => MenuCollapsed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$menuCollapsedHash() => r'2ea8457f081b9294415ece5bde5af8c23f04858c';

abstract class _$MenuCollapsed extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
