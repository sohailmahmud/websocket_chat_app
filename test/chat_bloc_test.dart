import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:websocket_chat_app/core/error/failures.dart';
import 'package:websocket_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/connect_websocket.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/disconnect_websocket.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:websocket_chat_app/features/chat/domain/repositories/chat_repository.dart';

@GenerateMocks([ConnectWebSocket, DisconnectWebSocket, SendMessage, ChatRepository])
import 'chat_bloc_test.mocks.dart';

void main() {
  late MockConnectWebSocket mockConnectWebSocket;
  late MockDisconnectWebSocket mockDisconnectWebSocket;
  late MockSendMessage mockSendMessage;
  late MockChatRepository mockChatRepository;
  late ChatBloc chatBloc;

  setUp(() {
    mockConnectWebSocket = MockConnectWebSocket();
    mockDisconnectWebSocket = MockDisconnectWebSocket();
    mockSendMessage = MockSendMessage();
    mockChatRepository = MockChatRepository();
    chatBloc = ChatBloc(
      connectWebSocket: mockConnectWebSocket,
      disconnectWebSocket: mockDisconnectWebSocket,
      sendMessage: mockSendMessage,
      chatRepository: mockChatRepository,
    );
  });

  blocTest<ChatBloc, ChatState>(
    'emits [ChatConnecting, ChatConnected] when ConnectToWebSocket succeeds',
    build: () {
      when(mockConnectWebSocket.call(any)).thenAnswer((_) async => const Right(null));
      when(mockChatRepository.messageStream).thenAnswer((_) => const Stream.empty());
      return chatBloc;
    },
    act: (bloc) => bloc.add(const ConnectToWebSocket('ws://test')),
    expect: () => [ChatConnecting(), const ChatConnected([])],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [ChatConnecting, ChatError] when ConnectToWebSocket fails',
    build: () {
      when(mockConnectWebSocket.call(any)).thenAnswer((_) async => const Left(ConnectionFailure('fail')));
      return chatBloc;
    },
    act: (bloc) => bloc.add(const ConnectToWebSocket('ws://test')),
    expect: () => [ChatConnecting(), isA<ChatError>()],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [ChatDisconnected] when DisconnectFromWebSocket succeeds',
    build: () {
      when(mockDisconnectWebSocket.call(any)).thenAnswer((_) async => const Right(null));
      return chatBloc;
    },
    act: (bloc) => bloc.add(DisconnectFromWebSocket()),
    expect: () => [ChatDisconnected()],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [ChatError] when DisconnectFromWebSocket fails',
    build: () {
      when(mockDisconnectWebSocket.call(any)).thenAnswer((_) async => const Left(WebSocketFailure('fail')));
      return chatBloc;
    },
    act: (bloc) => bloc.add(DisconnectFromWebSocket()),
    expect: () => [isA<ChatError>()],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [ChatConnected] with new message when SendChatMessage succeeds',
    build: () {
      when(mockSendMessage.call(any)).thenAnswer((_) async => const Right(null));
      return chatBloc;
    },
    seed: () => ChatConnected([]),
    act: (bloc) => bloc.add(const SendChatMessage('Hello')),
    expect: () => [isA<ChatConnected>()],
  );
}
