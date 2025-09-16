import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';

class ConnectionButton extends StatefulWidget {
  const ConnectionButton({super.key});

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton> {
  final TextEditingController _urlController = TextEditingController(
    text: 'wss://echo.websocket.org',
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'WebSocket URL',
                  border: OutlineInputBorder(),
                ),
                enabled: state is! ChatConnecting,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: state is ChatConnected || state is ChatConnecting
                        ? null
                        : () {
                            final url = _urlController.text.trim();
                            if (url.isNotEmpty) {
                              context
                                  .read<ChatBloc>()
                                  .add(ConnectToWebSocket(url));
                            }
                          },
                    child: const Text('Connect'),
                  ),
                  ElevatedButton(
                    onPressed: state is ChatConnected
                        ? () {
                            context
                                .read<ChatBloc>()
                                .add(DisconnectFromWebSocket());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}