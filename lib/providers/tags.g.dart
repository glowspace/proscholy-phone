// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagHash() => r'2d88379df9977f54db1b1c06806a443c9be9e7ee';

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

/// See also [tag].
@ProviderFor(tag)
const tagProvider = TagFamily();

/// See also [tag].
class TagFamily extends Family<Tag?> {
  /// See also [tag].
  const TagFamily();

  /// See also [tag].
  TagProvider call(
    int id,
  ) {
    return TagProvider(
      id,
    );
  }

  @override
  TagProvider getProviderOverride(
    covariant TagProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'tagProvider';
}

/// See also [tag].
class TagProvider extends AutoDisposeProvider<Tag?> {
  /// See also [tag].
  TagProvider(
    int id,
  ) : this._internal(
          (ref) => tag(
            ref as TagRef,
            id,
          ),
          from: tagProvider,
          name: r'tagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$tagHash,
          dependencies: TagFamily._dependencies,
          allTransitiveDependencies: TagFamily._allTransitiveDependencies,
          id: id,
        );

  TagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    Tag? Function(TagRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TagProvider._internal(
        (ref) => create(ref as TagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Tag?> createElement() {
    return _TagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TagProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TagRef on AutoDisposeProviderRef<Tag?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TagProviderElement extends AutoDisposeProviderElement<Tag?> with TagRef {
  _TagProviderElement(super.provider);

  @override
  int get id => (origin as TagProvider).id;
}

String _$tagsHash() => r'074b72e023b471447eb00d117361b526195381af';

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
    TagType tagType,
  ) : this._internal(
          (ref) => tags(
            ref as TagsRef,
            tagType,
          ),
          from: tagsProvider,
          name: r'tagsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$tagsHash,
          dependencies: TagsFamily._dependencies,
          allTransitiveDependencies: TagsFamily._allTransitiveDependencies,
          tagType: tagType,
        );

  TagsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tagType,
  }) : super.internal();

  final TagType tagType;

  @override
  Override overrideWith(
    List<Tag> Function(TagsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TagsProvider._internal(
        (ref) => create(ref as TagsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tagType: tagType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Tag>> createElement() {
    return _TagsProviderElement(this);
  }

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

mixin TagsRef on AutoDisposeProviderRef<List<Tag>> {
  /// The parameter `tagType` of this provider.
  TagType get tagType;
}

class _TagsProviderElement extends AutoDisposeProviderElement<List<Tag>>
    with TagsRef {
  _TagsProviderElement(super.provider);

  @override
  TagType get tagType => (origin as TagsProvider).tagType;
}

String _$selectedTagsHash() => r'8506242a9d346751ad92effb99337595e2c17e63';

/// See also [SelectedTags].
@ProviderFor(SelectedTags)
final selectedTagsProvider = NotifierProvider<SelectedTags, Set<Tag>>.internal(
  SelectedTags.new,
  name: r'selectedTagsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedTagsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTags = Notifier<Set<Tag>>;
String _$selectedTagsByTypeHash() =>
    r'4de8cf236965b0cb7288b9c7170f47e4fb96fc95';

abstract class _$SelectedTagsByType extends BuildlessNotifier<Set<Tag>> {
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
    extends NotifierProviderImpl<SelectedTagsByType, Set<Tag>> {
  /// See also [SelectedTagsByType].
  SelectedTagsByTypeProvider(
    TagType tagType,
  ) : this._internal(
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
          tagType: tagType,
        );

  SelectedTagsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tagType,
  }) : super.internal();

  final TagType tagType;

  @override
  Set<Tag> runNotifierBuild(
    covariant SelectedTagsByType notifier,
  ) {
    return notifier.build(
      tagType,
    );
  }

  @override
  Override overrideWith(SelectedTagsByType Function() create) {
    return ProviderOverride(
      origin: this,
      override: SelectedTagsByTypeProvider._internal(
        () => create()..tagType = tagType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tagType: tagType,
      ),
    );
  }

  @override
  NotifierProviderElement<SelectedTagsByType, Set<Tag>> createElement() {
    return _SelectedTagsByTypeProviderElement(this);
  }

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
}

mixin SelectedTagsByTypeRef on NotifierProviderRef<Set<Tag>> {
  /// The parameter `tagType` of this provider.
  TagType get tagType;
}

class _SelectedTagsByTypeProviderElement
    extends NotifierProviderElement<SelectedTagsByType, Set<Tag>>
    with SelectedTagsByTypeRef {
  _SelectedTagsByTypeProviderElement(super.provider);

  @override
  TagType get tagType => (origin as SelectedTagsByTypeProvider).tagType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
