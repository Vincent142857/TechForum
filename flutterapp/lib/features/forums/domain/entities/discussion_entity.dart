import 'dart:ffi';

import 'package:equatable/equatable.dart';

class DiscussionAllEntity extends Equatable {
  final int? id;
  final String? title;
  final DateTime? createdAt;
  final String? username;
  final String? avatar;
  final String? imageUrl;
  final String? badgeName;

  const DiscussionAllEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.username,
    required this.avatar,
    required this.imageUrl,
    required this.badgeName,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        username,
        avatar,
        imageUrl,
        badgeName,
      ];
}
