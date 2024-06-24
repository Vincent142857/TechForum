import 'dart:convert';

import 'package:flutterapp/features/forums/domain/entities/discussion_entity.dart';

class DiscussionAllModel extends DiscussionAllEntity {
  const DiscussionAllModel({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.username,
    required super.avatar,
    required super.imageUrl,
    required super.badgeName,
  });

  factory DiscussionAllModel.fromMap(Map<String, dynamic> json) {
    return DiscussionAllModel(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      createdAt: DateTime.parse(json['createdAt']),
      username: (json['username'] ?? '') as String,
      avatar: (json['avatar'] ?? '') as String,
      imageUrl: (json['imageUrl'] ?? '') as String,
      badgeName: (json['badgeName'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt,
      "username": username,
      "avatar": avatar,
      "imageUrl": imageUrl,
      "badgeName": badgeName,
    };
  }

  factory DiscussionAllModel.fromJson(source) =>
      DiscussionAllModel.fromMap(source);
}
