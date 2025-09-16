import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:websocket_chat_app/features/chat/presentation/widgets/message_input.dart';

void main() {
  group('MessageInput Widget', () {
    testWidgets('renders input and button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageInput(enabled: true),
          ),
        ),
      );

  expect(find.byType(TextField), findsOneWidget);
  expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
