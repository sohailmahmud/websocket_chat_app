import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/disconnect_websocket.dart';
import 'package:websocket_chat_app/features/chat/presentation/widgets/connection_button.dart';
import 'package:websocket_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/connect_websocket.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:dartz/dartz.dart';
import 'package:websocket_chat_app/core/error/failures.dart';
import 'package:websocket_chat_app/features/chat/domain/entities/message.dart';
import 'package:websocket_chat_app/features/chat/domain/repositories/chat_repository.dart';
class FakeChatRepository implements ChatRepository {
  @override
  Future<Either<Failure, void>> connect(String url) async => const Right(null);
  @override
  Future<Either<Failure, void>> disconnect() async => const Right(null);
  @override
  Future<Either<Failure, void>> sendMessage(String message) async => const Right(null);
  @override
  Stream<Either<Failure, Message>> get messageStream => const Stream.empty();
  @override
  bool get isConnected => true;
}

void main() {
  group('ConnectionButton Widget', () {
    testWidgets('renders input and button', (WidgetTester tester) async {
      final fakeRepo = FakeChatRepository();
      final chatBloc = ChatBloc(
        chatRepository: fakeRepo,
        connectWebSocket: ConnectWebSocket(fakeRepo),
        disconnectWebSocket: DisconnectWebSocket(fakeRepo),
        sendMessage: SendMessage(fakeRepo),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: chatBloc,
              child: ConnectionButton(),
            ),
          ),
        ),
      );

  expect(find.byType(TextField), findsOneWidget);
  expect(find.byType(ElevatedButton), findsNWidgets(2));
    });
  });
}
