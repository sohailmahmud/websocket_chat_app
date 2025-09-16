import 'dart:convert';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.timestamp,
    super.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? json['message'] ?? '',
      sender: json['sender'] ?? json['user'] ?? 'Unknown',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      status: _statusFromString(json['status']),
    );
  }

  factory MessageModel.fromString(String data) {
    try {
      final json = jsonDecode(data);
      return MessageModel.fromJson(json);
    } catch (e) {
      // Handle plain text messages
      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: data,
        sender: 'Server',
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  static MessageStatus _statusFromString(dynamic value) {
    if (value is String) {
      return MessageStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => MessageStatus.sent,
      );
    }
    return MessageStatus.sent;
  }
}