import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_state.freezed.dart';

@freezed
class TodoState with _$TodoState {
  const factory TodoState({
    @Default('') String? id,
    @Default('') String title,
    @Default('') String description,
    @Default(true) bool isPublish,
    @Default('') String createdBy,
    @Default('') String? image,
    @Default(0) int likesCount,
    @Default([]) List<String> likedByUsers,
    Uint8List? imageData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TodoState;
}
