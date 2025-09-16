import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:websocket_chat_app/features/chat/presentation/bloc/chat_bloc.dart';

// Reuse mocks generated in chat_bloc_test to avoid duplicate generation
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

  group('Typing & Presence', () {
    blocTest<ChatBloc, ChatState>(
      'TypingStarted then TypingStopped toggles isOtherTyping',
      build: () {
        when(mockConnectWebSocket.call(any)).thenAnswer((_) async => const Right(null));
        when(mockChatRepository.messageStream).thenAnswer((_) => const Stream.empty());
        return chatBloc;
      },
      act: (bloc) async {
        bloc.add(const ConnectToWebSocket('ws://test'));
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const TypingStarted());
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const TypingStopped());
      },
      expect: () => [
        ChatConnecting(),
        const ChatConnected([]),
        const ChatConnected([], isOtherTyping: true),
        const ChatConnected([], isOtherTyping: false),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'PresenceUpdated changes isOtherOnline flag',
      build: () {
        when(mockConnectWebSocket.call(any)).thenAnswer((_) async => const Right(null));
        when(mockChatRepository.messageStream).thenAnswer((_) => const Stream.empty());
        return chatBloc;
      },
      act: (bloc) async {
        bloc.add(const ConnectToWebSocket('ws://test'));
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const PresenceUpdated(false));
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const PresenceUpdated(true));
      },
      expect: () => [
        ChatConnecting(),
        const ChatConnected([]),
        const ChatConnected([], isOtherOnline: false),
        const ChatConnected([]),
      ],
    );
  });
}
