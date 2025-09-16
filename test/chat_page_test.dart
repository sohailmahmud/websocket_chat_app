import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/disconnect_websocket.dart';
import 'package:websocket_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:websocket_chat_app/features/chat/presentation/widgets/chat_page.dart';
import 'package:dartz/dartz.dart';
import 'package:websocket_chat_app/core/error/failures.dart';
import 'package:websocket_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/connect_websocket.dart';
import 'package:websocket_chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:websocket_chat_app/features/chat/domain/entities/message.dart';


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
  group('ChatPage Widget', () {
    late ChatBloc chatBloc;


    setUp(() {
      final fakeRepo = FakeChatRepository();
      chatBloc = ChatBloc(
        chatRepository: fakeRepo,
        connectWebSocket: ConnectWebSocket(fakeRepo),
        disconnectWebSocket: DisconnectWebSocket(fakeRepo),
        sendMessage: SendMessage(fakeRepo),
      );
      chatBloc.emit(const ChatConnected([]));
    });

    testWidgets('renders ChatPage and finds key widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: chatBloc,
            child: const ChatPage(),
          ),
        ),
      );

  expect(find.text('WebSocket Chat'), findsOneWidget);
  expect(find.byType(AppBar), findsOneWidget);
  expect(find.byType(Scaffold), findsOneWidget);
  expect(find.byType(TextField), findsNWidgets(2));
  expect(find.byType(ElevatedButton), findsWidgets);
  expect(find.byType(ListView), findsOneWidget);
    });
  });
}
