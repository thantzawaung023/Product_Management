import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/utils/utils.dart';

part 'like_info.freezed.dart';
part 'like_info.g.dart';

@freezed
class LikeInfo with _$LikeInfo {
  factory LikeInfo({
    required String userId,
    @TimestampConverter() required DateTime likeAt,
  }) = _LikeInfo;

  factory LikeInfo.fromJson(Map<String, Object?> json) =>
      _$LikeInfoFromJson(json);
}
