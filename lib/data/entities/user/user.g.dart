// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      profile: json['profile'] as String?,
      address: const NullableAddressConverters()
          .fromJson(json['address'] as Map<String, dynamic>?),
      providerData: (json['providerData'] as List<dynamic>?)
          ?.map(const UserProviderDataConverter().fromJson)
          .toList(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'profile': instance.profile,
      'address': const NullableAddressConverters().toJson(instance.address),
      'providerData': instance.providerData
          ?.map(const UserProviderDataConverter().toJson)
          .toList(),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
