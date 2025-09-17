// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tag)
const tagProvider = TagFamily._();

final class TagProvider extends $FunctionalProvider<Tag?, Tag?, Tag?>
    with $Provider<Tag?> {
  const TagProvider._(
      {required TagFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'tagProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tagHash();

  @override
  String toString() {
    return r'tagProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Tag?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Tag? create(Ref ref) {
    final argument = this.argument as int;
    return tag(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Tag? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Tag?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TagProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tagHash() => r'2d88379df9977f54db1b1c06806a443c9be9e7ee';

final class TagFamily extends $Family
    with $FunctionalFamilyOverride<Tag?, int> {
  const TagFamily._()
      : super(
          retry: null,
          name: r'tagProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TagProvider call(
    int id,
  ) =>
      TagProvider._(argument: id, from: this);

  @override
  String toString() => r'tagProvider';
}

@ProviderFor(tags)
const tagsProvider = TagsFamily._();

final class TagsProvider
    extends $FunctionalProvider<List<Tag>, List<Tag>, List<Tag>>
    with $Provider<List<Tag>> {
  const TagsProvider._(
      {required TagsFamily super.from, required TagType super.argument})
      : super(
          retry: null,
          name: r'tagsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tagsHash();

  @override
  String toString() {
    return r'tagsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Tag>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Tag> create(Ref ref) {
    final argument = this.argument as TagType;
    return tags(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Tag> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Tag>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TagsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tagsHash() => r'122ab1c1801b1bdbfef67e404e58ea86f31304ba';

final class TagsFamily extends $Family
    with $FunctionalFamilyOverride<List<Tag>, TagType> {
  const TagsFamily._()
      : super(
          retry: null,
          name: r'tagsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TagsProvider call(
    TagType tagType,
  ) =>
      TagsProvider._(argument: tagType, from: this);

  @override
  String toString() => r'tagsProvider';
}

@ProviderFor(SelectedTags)
const selectedTagsProvider = SelectedTagsProvider._();

final class SelectedTagsProvider
    extends $NotifierProvider<SelectedTags, Set<Tag>> {
  const SelectedTagsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedTagsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedTagsHash();

  @$internal
  @override
  SelectedTags create() => SelectedTags();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<Tag> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<Tag>>(value),
    );
  }
}

String _$selectedTagsHash() => r'8506242a9d346751ad92effb99337595e2c17e63';

abstract class _$SelectedTags extends $Notifier<Set<Tag>> {
  Set<Tag> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<Tag>, Set<Tag>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<Tag>, Set<Tag>>, Set<Tag>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedTagsByType)
const selectedTagsByTypeProvider = SelectedTagsByTypeFamily._();

final class SelectedTagsByTypeProvider
    extends $NotifierProvider<SelectedTagsByType, Set<Tag>> {
  const SelectedTagsByTypeProvider._(
      {required SelectedTagsByTypeFamily super.from,
      required TagType super.argument})
      : super(
          retry: null,
          name: r'selectedTagsByTypeProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedTagsByTypeHash();

  @override
  String toString() {
    return r'selectedTagsByTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedTagsByType create() => SelectedTagsByType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<Tag> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<Tag>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedTagsByTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedTagsByTypeHash() =>
    r'4de8cf236965b0cb7288b9c7170f47e4fb96fc95';

final class SelectedTagsByTypeFamily extends $Family
    with
        $ClassFamilyOverride<SelectedTagsByType, Set<Tag>, Set<Tag>, Set<Tag>,
            TagType> {
  const SelectedTagsByTypeFamily._()
      : super(
          retry: null,
          name: r'selectedTagsByTypeProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  SelectedTagsByTypeProvider call(
    TagType tagType,
  ) =>
      SelectedTagsByTypeProvider._(argument: tagType, from: this);

  @override
  String toString() => r'selectedTagsByTypeProvider';
}

abstract class _$SelectedTagsByType extends $Notifier<Set<Tag>> {
  late final _$args = ref.$arg as TagType;
  TagType get tagType => _$args;

  Set<Tag> build(
    TagType tagType,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<Set<Tag>, Set<Tag>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<Tag>, Set<Tag>>, Set<Tag>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
