import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:websocket_chat_app/core/usecases/usecase.dart';
import 'package:websocket_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/connect_websocket.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/disconnect_websocket.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/send_message.dart';

@GenerateMocks([ChatRepository])
import 'chat_usecases_test.mocks.dart';

void main() {
  late MockChatRepository mockChatRepository;
  late ConnectWebSocket connectWebSocket;
  late DisconnectWebSocket disconnectWebSocket;
  late SendMessage sendMessage;

  setUp(() {
    mockChatRepository = MockChatRepository();
    connectWebSocket = ConnectWebSocket(mockChatRepository);
    disconnectWebSocket = DisconnectWebSocket(mockChatRepository);
    sendMessage = SendMessage(mockChatRepository);
  });

  test('ConnectWebSocket calls repository.connect', () async {
    when(mockChatRepository.connect(any)).thenAnswer((_) async => const Right(null));
    final result = await connectWebSocket(ConnectParams(url: 'ws://test'));
    expect(result, equals(const Right(null)));
    verify(mockChatRepository.connect('ws://test')).called(1);
  });

  test('DisconnectWebSocket calls repository.disconnect', () async {
    when(mockChatRepository.disconnect()).thenAnswer((_) async => const Right(null));
    final result = await disconnectWebSocket(NoParams());
    expect(result, equals(const Right(null)));
    verify(mockChatRepository.disconnect()).called(1);
  });

  test('SendMessage calls repository.sendMessage', () async {
    when(mockChatRepository.sendMessage(any)).thenAnswer((_) async => const Right(null));
    final result = await sendMessage(SendMessageParams(message: 'Hello'));
    expect(result, equals(const Right(null)));
    verify(mockChatRepository.sendMessage('Hello')).called(1);
  });
}
