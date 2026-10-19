// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(graphQLClient)
final graphQLClientProvider = GraphQLClientProvider._();

final class GraphQLClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  GraphQLClientProvider._()
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
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return graphQLClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$graphQLClientHash() => r'0034d3d19e3decdb5e1a4b9c744a6de031d89b74';

@ProviderFor(update)
final updateProvider = UpdateProvider._();

final class UpdateProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpdateStatus>,
          UpdateStatus,
          Stream<UpdateStatus>
        >
    with $FutureModifier<UpdateStatus>, $StreamProvider<UpdateStatus> {
  UpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UpdateStatus> create(Ref ref) {
    return update(ref);
  }
}

String _$updateHash() => r'9bd4400e3bb918b45d4271eda9ce7f94212366e9';
