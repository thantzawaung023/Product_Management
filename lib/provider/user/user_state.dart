import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:product_management/data/entities/address/address.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default('') String? id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String? profile,
    @Default('') String password,
    Address? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uint8List? imageData,
  }) = _UserState;
}
