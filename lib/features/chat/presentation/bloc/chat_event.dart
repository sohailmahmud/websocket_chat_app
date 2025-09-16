part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ConnectToWebSocket extends ChatEvent {
  final String url;

  const ConnectToWebSocket(this.url);

  @override
  List<Object> get props => [url];
}

class DisconnectFromWebSocket extends ChatEvent {}

class SendChatMessage extends ChatEvent {
  final String message;

  const SendChatMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceived extends ChatEvent {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class ErrorOccurred extends ChatEvent {
  final String error;

  const ErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}