import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:websocket_chat_app/features/chat/presentation/widgets/message_list.dart';
import 'package:websocket_chat_app/features/chat/domain/entities/message.dart';

void main() {
  group('MessageList Widget', () {
    testWidgets('renders messages correctly', (WidgetTester tester) async {
      final messages = [
        Message(
          id: '1',
          content: 'Hello',
          sender: 'You',
          timestamp: DateTime.now(),
        ),
        Message(
          id: '2',
          content: 'Hi!',
          sender: 'Other',
          timestamp: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageList(messages: messages),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi!'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
