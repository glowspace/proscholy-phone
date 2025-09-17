// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../svgs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Svgs)
const svgsProvider = SvgsProvider._();

final class SvgsProvider
    extends $NotifierProvider<Svgs, Map<String, FileSystemEntity>> {
  const SvgsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'svgsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$svgsHash();

  @$internal
  @override
  Svgs create() => Svgs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, FileSystemEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<String, FileSystemEntity>>(value),
    );
  }
}

String _$svgsHash() => r'1b27a273e3d071a402ff874f8865ce7637c011ec';

abstract class _$Svgs extends $Notifier<Map<String, FileSystemEntity>> {
  Map<String, FileSystemEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<Map<String, FileSystemEntity>, Map<String, FileSystemEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, FileSystemEntity>,
            Map<String, FileSystemEntity>>,
        Map<String, FileSystemEntity>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Svg)
const svgProvider = SvgFamily._();

final class SvgProvider extends $NotifierProvider<Svg, String> {
  const SvgProvider._(
      {required SvgFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'svgProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$svgHash();

  @override
  String toString() {
    return r'svgProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Svg create() => Svg();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SvgProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$svgHash() => r'b914e952dee78cce383080765a1ea85b6ab0694f';

final class SvgFamily extends $Family
    with $ClassFamilyOverride<Svg, String, String, String, int> {
  const SvgFamily._()
      : super(
          retry: null,
          name: r'svgProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SvgProvider call(
    int songLyricId,
  ) =>
      SvgProvider._(argument: songLyricId, from: this);

  @override
  String toString() => r'svgProvider';
}

abstract class _$Svg extends $Notifier<String> {
  late final _$args = ref.$arg as int;
  int get songLyricId => _$args;

  String build(
    int songLyricId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
