import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:websocket_chat_app/features/chat/presentation/widgets/message_input.dart';

void main() {
  group('MessageInput Widget', () {
    testWidgets('renders input and action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MessageInput(enabled: true),
          ),
        ),
      );

      // WhatsApp-like input should include a TextField
      expect(find.byType(TextField), findsOneWidget);

      // And at least one IconButton (emoji/attach/camera or action button)
      expect(find.byType(IconButton), findsWidgets);
    });
  });
}
