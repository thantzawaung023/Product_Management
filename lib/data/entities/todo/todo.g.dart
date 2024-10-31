// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isPublish: json['isPublish'] as bool,
      image: json['image'] as String?,
      createdBy: json['createdBy'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
      likedByUsers: (json['likedByUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isPublish': instance.isPublish,
      'image': instance.image,
      'createdBy': instance.createdBy,
      'likesCount': instance.likesCount,
      'likedByUsers': instance.likedByUsers,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
