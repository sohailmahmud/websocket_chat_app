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
        
        final result = await sendMessage(SendMessageParams(message: event.message));
        
        result.fold(
          (failure) => emit(ChatError(failure.message ?? 'Failed to send message')),
          (_) {
            // Add the sent message to local state
            final sentMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: event.message,
              sender: 'You',
              timestamp: DateTime.now(),
            );
            
            final updatedMessages = [...currentState.messages, sentMessage];
            emit(ChatConnected(updatedMessages));
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