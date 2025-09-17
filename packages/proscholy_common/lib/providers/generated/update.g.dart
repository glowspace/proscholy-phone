// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(graphQLClient)
const graphQLClientProvider = GraphQLClientProvider._();

final class GraphQLClientProvider
    extends $FunctionalProvider<Client, Client, Client> with $Provider<Client> {
  const GraphQLClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'graphQLClientProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$graphQLClientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return graphQLClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$graphQLClientHash() => r'9f6e28b05c9d7c2b492b193f830631ce52f58d46';

@ProviderFor(update)
const updateProvider = UpdateProvider._();

final class UpdateProvider extends $FunctionalProvider<AsyncValue<UpdateStatus>,
        UpdateStatus, Stream<UpdateStatus>>
    with $FutureModifier<UpdateStatus>, $StreamProvider<UpdateStatus> {
  const UpdateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateHash();

  @$internal
  @override
  $StreamProviderElement<UpdateStatus> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<UpdateStatus> create(Ref ref) {
    return update(ref);
  }
}

String _$updateHash() => r'414e6ba8dfeab996560461466a49932a1019692b';
