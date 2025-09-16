part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatConnected extends ChatState {
  final List<Message> messages;
  final bool isOtherTyping;
  final bool isOtherOnline;

  const ChatConnected(
    this.messages, {
    this.isOtherTyping = false,
    this.isOtherOnline = true,
  });

  ChatConnected copyWith({
    List<Message>? messages,
    bool? isOtherTyping,
    bool? isOtherOnline,
  }) => ChatConnected(
        messages ?? this.messages,
        isOtherTyping: isOtherTyping ?? this.isOtherTyping,
        isOtherOnline: isOtherOnline ?? this.isOtherOnline,
      );

  @override
  List<Object> get props => [messages, isOtherTyping, isOtherOnline];
}

class ChatDisconnected extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}