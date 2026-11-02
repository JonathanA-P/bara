import 'package:flutter/material.dart';

enum PostCategoryTab { kuliah, luarKelas }

class PostBadge {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const PostBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
}

class PostModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String? userRole;
  final PostCategoryTab tab;
  final List<PostBadge> badges;
  final String title;
  final String content;
  final String? imageAttachment;
  final String? fileAttachment;
  final String? fileSize;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isBookmarked;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    this.userRole,
    required this.tab,
    required this.badges,
    required this.title,
    required this.content,
    this.imageAttachment,
    this.fileAttachment,
    this.fileSize,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  PostModel copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? timeAgo,
    String? userRole,
    PostCategoryTab? tab,
    List<PostBadge>? badges,
    String? title,
    String? content,
    String? imageAttachment,
    String? fileAttachment,
    String? fileSize,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      timeAgo: timeAgo ?? this.timeAgo,
      userRole: userRole ?? this.userRole,
      tab: tab ?? this.tab,
      badges: badges ?? this.badges,
      title: title ?? this.title,
      content: content ?? this.content,
      imageAttachment: imageAttachment ?? this.imageAttachment,
      fileAttachment: fileAttachment ?? this.fileAttachment,
      fileSize: fileSize ?? this.fileSize,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

