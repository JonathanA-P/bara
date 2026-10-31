import 'package:flutter/material.dart';
import 'notification_chat_screen.dart';

export 'notification_chat_screen.dart';
export 'direct_chat_screen.dart';
export 'camera_screen.dart';

class ChatConversation {
  final String id;
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String? activeSessionTag;

  ChatConversation({
    required this.id,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.activeSessionTag,
  });
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationChatScreen(initialTabIndex: 1);
  }
}
