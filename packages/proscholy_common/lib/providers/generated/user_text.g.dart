// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_text.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userText)
final userTextProvider = UserTextFamily._();

final class UserTextProvider
    extends $FunctionalProvider<UserText?, UserText?, UserText?>
    with $Provider<UserText?> {
  UserTextProvider._({
    required UserTextFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'userTextProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userTextHash();

  @override
  String toString() {
    return r'userTextProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<UserText?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserText? create(Ref ref) {
    final argument = this.argument as int;
    return userText(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserText? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserText?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserTextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userTextHash() => r'5641375e3ca6b0b85045f658dd90c048957f222b';

final class UserTextFamily extends $Family
    with $FunctionalFamilyOverride<UserText?, int> {
  UserTextFamily._()
    : super(
        retry: null,
        name: r'userTextProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserTextProvider call(int id) => UserTextProvider._(argument: id, from: this);

  @override
  String toString() => r'userTextProvider';
}
