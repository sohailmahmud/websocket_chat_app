import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/connect_websocket.dart';
import '../../domain/usecases/disconnect_websocket.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectWebSocket connectWebSocket;
  final DisconnectWebSocket disconnectWebSocket;
  final SendMessage sendMessage;
  final ChatRepository chatRepository;
  
  StreamSubscription<dynamic>? _messageSubscription;

  ChatBloc({
    required this.connectWebSocket,
    required this.disconnectWebSocket,
    required this.sendMessage,
    required this.chatRepository,
  }) : super(ChatInitial()) {
    
    on<ConnectToWebSocket>((event, emit) async {
      emit(ChatConnecting());
      
      final result = await connectWebSocket(ConnectParams(url: event.url));
      
      result.fold(
        (failure) => emit(ChatError(failure.message ?? 'Connection failed')),
        (_) {
          emit(const ChatConnected([]));
          _listenToMessages();
        },
      );
    });

    on<DisconnectFromWebSocket>((event, emit) async {
      await _messageSubscription?.cancel();
      
      final result = await disconnectWebSocket(NoParams());
      
      result.fold(
        (failure) => emit(ChatError(failure.message ?? 'Disconnect failed')),
        (_) => emit(ChatDisconnected()),
      );
    });

    on<SendChatMessage>((event, emit) async {
      if (state is ChatConnected) {
        final currentState = state as ChatConnected;
        
        // Optimistically add message with sending status
        final tempMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: event.message,
          sender: 'You',
          timestamp: DateTime.now(),
          status: MessageStatus.sending,
        );
        emit(ChatConnected([...currentState.messages, tempMessage]));

        final result = await sendMessage(SendMessageParams(message: event.message));

        result.fold(
          (failure) => emit(ChatError(failure.message ?? 'Failed to send message')),
          (_) {
            // Promote to sent
            add(UpdateMessageStatus(tempMessage.id, MessageStatus.sent));
            // Simulate delivery after short delay
            Future.delayed(const Duration(milliseconds: 400), () {
              add(UpdateMessageStatus(tempMessage.id, MessageStatus.delivered));
            });
            // Simulate read after additional delay
            Future.delayed(const Duration(seconds: 1), () {
              add(UpdateMessageStatus(tempMessage.id, MessageStatus.read));
            });
          },
        );
      }
    });

    on<MessageReceived>((event, emit) {
      if (state is ChatConnected) {
        final currentState = state as ChatConnected;
        final updatedMessages = [...currentState.messages, event.message];
        emit(ChatConnected(updatedMessages));
      }
    });

    on<UpdateMessageStatus>((event, emit) {
      if (state is ChatConnected) {
        final currentState = state as ChatConnected;
        final updatedMessages = currentState.messages.map((m) {
          if (m.id == event.messageId) {
            return Message(
              id: m.id,
              content: m.content,
              sender: m.sender,
              timestamp: m.timestamp,
              status: event.status,
            );
          }
          return m;
        }).toList();
        emit(ChatConnected(updatedMessages));
      }
    });

    // Typing indicator events
    on<TypingStarted>((event, emit) {
      if (state is ChatConnected) {
        final currentState = state as ChatConnected;
        if (!currentState.isOtherTyping) {
          emit(currentState.copyWith(isOtherTyping: true));
        }
      }
    });

    on<TypingStopped>((event, emit) {
      if (state is ChatConnected) {
        final currentState = state as ChatConnected;
        if (currentState.isOtherTyping) {
          emit(currentState.copyWith(isOtherTyping: false));
        }
      }
    });

    // Presence updates
    on<PresenceUpdated>((event, emit) {
      if (state is ChatConnected) {
        final currentState = state as ChatConnected;
        if (currentState.isOtherOnline != event.isOnline) {
          emit(currentState.copyWith(isOtherOnline: event.isOnline));
        }
      }
    });
  }

  void _listenToMessages() {
    _messageSubscription = chatRepository.messageStream.listen(
      (either) {
        either.fold(
          (failure) => add(ErrorOccurred(failure.message ?? 'Unknown error')),
          (message) => add(MessageReceived(message)),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}