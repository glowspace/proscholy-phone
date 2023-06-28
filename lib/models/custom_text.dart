import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist_record.dart';

part 'custom_text.freezed.dart';

@freezed
class CustomText with _$CustomText implements Identifiable {
  @Entity(realClass: CustomText)
  const factory CustomText({
    @Id(assignable: true) required int id,
    required String name,
    required String content,
    @Backlink() required ToMany<PlaylistRecord> playlistRecords,
  }) = _CustomText;
}
