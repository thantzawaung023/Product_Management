// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LikeInfoImpl _$$LikeInfoImplFromJson(Map<String, dynamic> json) =>
    _$LikeInfoImpl(
      userId: json['userId'] as String,
      likeAt: const TimestampConverter().fromJson(json['likeAt'] as Timestamp),
    );

Map<String, dynamic> _$$LikeInfoImplToJson(_$LikeInfoImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'likeAt': const TimestampConverter().toJson(instance.likeAt),
    };
