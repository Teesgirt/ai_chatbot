class MessageEntity {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  MessageEntity({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}