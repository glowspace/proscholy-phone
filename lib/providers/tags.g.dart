// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagsHash() => r'074b72e023b471447eb00d117361b526195381af';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef TagsRef = AutoDisposeProviderRef<List<Tag>>;

/// See also [tags].
@ProviderFor(tags)
const tagsProvider = TagsFamily();

/// See also [tags].
class TagsFamily extends Family<List<Tag>> {
  /// See also [tags].
  const TagsFamily();

  /// See also [tags].
  TagsProvider call(
    TagType tagType,
  ) {
    return TagsProvider(
      tagType,
    );
  }

  @override
  TagsProvider getProviderOverride(
    covariant TagsProvider provider,
  ) {
    return call(
      provider.tagType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tagsProvider';
}

/// See also [tags].
class TagsProvider extends AutoDisposeProvider<List<Tag>> {
  /// See also [tags].
  TagsProvider(
    this.tagType,
  ) : super.internal(
          (ref) => tags(
            ref,
            tagType,
          ),
          from: tagsProvider,
          name: r'tagsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$tagsHash,
          dependencies: TagsFamily._dependencies,
          allTransitiveDependencies: TagsFamily._allTransitiveDependencies,
        );

  final TagType tagType;

  @override
  bool operator ==(Object other) {
    return other is TagsProvider && other.tagType == tagType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tagType.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$selectedTagsHash() => r'234e8ee7fb1abf6aac608b2f2340aaf2fdc77f68';

/// See also [SelectedTags].
@ProviderFor(SelectedTags)
final selectedTagsProvider =
    AutoDisposeNotifierProvider<SelectedTags, Set<Tag>>.internal(
  SelectedTags.new,
  name: r'selectedTagsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedTagsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTags = AutoDisposeNotifier<Set<Tag>>;
String _$selectedTagsByTypeHash() =>
    r'7fe1982268c908600e9bb6fca1b2cac70c657756';

abstract class _$SelectedTagsByType
    extends BuildlessAutoDisposeNotifier<Set<Tag>> {
  late final TagType tagType;

  Set<Tag> build(
    TagType tagType,
  );
}

/// See also [SelectedTagsByType].
@ProviderFor(SelectedTagsByType)
const selectedTagsByTypeProvider = SelectedTagsByTypeFamily();

/// See also [SelectedTagsByType].
class SelectedTagsByTypeFamily extends Family<Set<Tag>> {
  /// See also [SelectedTagsByType].
  const SelectedTagsByTypeFamily();

  /// See also [SelectedTagsByType].
  SelectedTagsByTypeProvider call(
    TagType tagType,
  ) {
    return SelectedTagsByTypeProvider(
      tagType,
    );
  }

  @override
  SelectedTagsByTypeProvider getProviderOverride(
    covariant SelectedTagsByTypeProvider provider,
  ) {
    return call(
      provider.tagType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'selectedTagsByTypeProvider';
}

/// See also [SelectedTagsByType].
class SelectedTagsByTypeProvider
    extends AutoDisposeNotifierProviderImpl<SelectedTagsByType, Set<Tag>> {
  /// See also [SelectedTagsByType].
  SelectedTagsByTypeProvider(
    this.tagType,
  ) : super.internal(
          () => SelectedTagsByType()..tagType = tagType,
          from: selectedTagsByTypeProvider,
          name: r'selectedTagsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedTagsByTypeHash,
          dependencies: SelectedTagsByTypeFamily._dependencies,
          allTransitiveDependencies:
              SelectedTagsByTypeFamily._allTransitiveDependencies,
        );

  final TagType tagType;

  @override
  bool operator ==(Object other) {
    return other is SelectedTagsByTypeProvider && other.tagType == tagType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tagType.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Set<Tag> runNotifierBuild(
    covariant SelectedTagsByType notifier,
  ) {
    return notifier.build(
      tagType,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
