import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_provider_data.freezed.dart';
part 'user_provider_data.g.dart';

@freezed
class UserProviderData with _$UserProviderData {
  const factory UserProviderData({
    @Default('') String userName,
    @Default('') String email,
    @Default('') String providerType,
    @Default('') String uid,
    @Default('') String photoUrl,
  }) = _UserProviderData;

  factory UserProviderData.fromJson(Map<String, dynamic> json) =>
      _$UserProviderDataFromJson(json);
}
