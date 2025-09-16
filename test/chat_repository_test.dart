import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:websocket_chat_app/core/error/failures.dart';
import 'package:websocket_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:websocket_chat_app/features/chat/domain/entities/message.dart';
import 'package:dartz/dartz.dart';


@GenerateMocks([ChatRepository])
import 'chat_repository_test.mocks.dart';

void main() {
  group('ChatRepository', () {
  late MockChatRepository mockChatRepository;

    setUp(() {
      mockChatRepository = MockChatRepository();
    });

    test('connect returns Right when successful', () async {
      when(mockChatRepository.connect(any)).thenAnswer((_) async => const Right(null));
      final result = await mockChatRepository.connect('ws://test');
      expect(result, equals(const Right(null)));
      verify(mockChatRepository.connect('ws://test')).called(1);
    });

    test('disconnect returns Right when successful', () async {
      when(mockChatRepository.disconnect()).thenAnswer((_) async => const Right(null));
      final result = await mockChatRepository.disconnect();
      expect(result, equals(const Right(null)));
      verify(mockChatRepository.disconnect()).called(1);
    });

    test('sendMessage returns Right when successful', () async {
      when(mockChatRepository.sendMessage(any)).thenAnswer((_) async => const Right(null));
      final result = await mockChatRepository.sendMessage('Hello');
      expect(result, equals(const Right(null)));
      verify(mockChatRepository.sendMessage('Hello')).called(1);
    });

    test('isConnected returns true when connected', () {
      when(mockChatRepository.isConnected).thenReturn(true);
      expect(mockChatRepository.isConnected, isTrue);
    });

    test('messageStream emits messages', () async {
      final message = Message(
        id: '1',
        content: 'Hello',
        sender: 'User',
        timestamp: DateTime.now(),
      );
      final stream = Stream<Either<Failure, Message>>.value(Right(message));
      when(mockChatRepository.messageStream).thenAnswer((_) => stream);
      expectLater(mockChatRepository.messageStream, emits(Right(message)));
    });
  });
}
