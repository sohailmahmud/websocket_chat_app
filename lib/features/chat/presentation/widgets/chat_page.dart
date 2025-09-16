import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_list.dart';
import '../widgets/message_input.dart';
import '../widgets/connection_button.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD), // WhatsApp chat background
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54), // WhatsApp green
        foregroundColor: Colors.white,
        elevation: 0,
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            String subtitle;
            Color dotColor;

            if (state is ChatConnecting) {
              subtitle = 'Connecting...';
              dotColor = Colors.orange;
            } else if (state is ChatConnected) {
              if (state.isOtherTyping) {
                subtitle = 'typing...';
              } else if (state.isOtherOnline) {
                subtitle = 'online';
              } else {
                subtitle = 'offline';
              }
              dotColor = state.isOtherOnline ? Colors.green : Colors.grey;
            } else if (state is ChatError) {
              subtitle = 'error';
              dotColor = Colors.red;
            } else if (state is ChatDisconnected) {
              subtitle = 'disconnected';
              dotColor = Colors.red;
            } else {
              subtitle = 'idle';
              dotColor = Colors.grey;
            }

            return Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'WebSocket Chat',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                            child: Text(
                              subtitle,
                              key: ValueKey(subtitle),
                              style: TextStyle(
                                color: subtitle == 'typing...' ? Colors.white : Colors.white70,
                                fontStyle: subtitle == 'typing...' ? FontStyle.italic : FontStyle.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          const ConnectionButton(),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatInitial) {
                  return const Center(
                    child: Text('Connect to start chatting'),
                  );
                } else if (state is ChatConnecting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ChatConnected) {
                  return MessageList(messages: state.messages);
                } else if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Disconnected'),
                  );
                }
              },
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return MessageInput(
                enabled: state is ChatConnected,
              );
            },
          ),
        ],
      ),
    );
  }

  // Removed old _buildConnectionStatus method in favor of dynamic subtitle in AppBar
}