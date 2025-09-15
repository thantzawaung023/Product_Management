import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class LikedByUserConverter
    implements JsonConverter<Map<String, DateTime>, Map<String, dynamic>> {
  const LikedByUserConverter();

  @override
  Map<String, DateTime> fromJson(Map<String, dynamic> json) {
    return json
        .map((key, value) => MapEntry(key, (value as Timestamp).toDate()));
  }

  @override
  Map<String, dynamic> toJson(Map<String, DateTime> likedByUsers) {
    return likedByUsers
        .map((key, value) => MapEntry(key, Timestamp.fromDate(value)));
  }
}
