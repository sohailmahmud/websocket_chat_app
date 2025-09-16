import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final String sender;
  final DateTime timestamp;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  @override
  List<Object> get props => [id, content, sender, timestamp, status];
}

enum MessageStatus { sending, sent, delivered, read }