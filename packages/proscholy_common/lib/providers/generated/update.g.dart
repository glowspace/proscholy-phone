// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$graphQLClientHash() => r'64a66c01751ad42509b410f348790661f8d53244';

/// See also [graphQLClient].
@ProviderFor(graphQLClient)
final graphQLClientProvider = Provider<Client>.internal(
  graphQLClient,
  name: r'graphQLClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$graphQLClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphQLClientRef = ProviderRef<Client>;
String _$updateHash() => r'750ab02cb407c3e1c213e049ed79e4030496b9b6';

/// See also [update].
@ProviderFor(update)
final updateProvider = AutoDisposeStreamProvider<UpdateStatus>.internal(
  update,
  name: r'updateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$updateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateRef = AutoDisposeStreamProviderRef<UpdateStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
