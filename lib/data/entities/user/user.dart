import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/data/entities/address/address.dart';
import 'package:product_management/data/entities/user_provider_data/user_provider_data.dart';
import 'package:product_management/utils/converters/user_pro_data_con.dart';
import 'package:product_management/utils/utils.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String password,
    String? profile,
    @NullableAddressConverters() Address? address,
    @UserProviderDataConverter() List<UserProviderData>? providerData,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
