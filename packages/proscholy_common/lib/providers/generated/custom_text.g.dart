// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../custom_text.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customText)
const customTextProvider = CustomTextFamily._();

final class CustomTextProvider
    extends $FunctionalProvider<CustomText?, CustomText?, CustomText?>
    with $Provider<CustomText?> {
  const CustomTextProvider._(
      {required CustomTextFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'customTextProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customTextHash();

  @override
  String toString() {
    return r'customTextProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CustomText?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CustomText? create(Ref ref) {
    final argument = this.argument as int;
    return customText(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomText? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomText?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CustomTextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customTextHash() => r'73a8abd66b7804a6291dbd7d640efaf466af491d';

final class CustomTextFamily extends $Family
    with $FunctionalFamilyOverride<CustomText?, int> {
  const CustomTextFamily._()
      : super(
          retry: null,
          name: r'customTextProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CustomTextProvider call(
    int id,
  ) =>
      CustomTextProvider._(argument: id, from: this);

  @override
  String toString() => r'customTextProvider';
}
