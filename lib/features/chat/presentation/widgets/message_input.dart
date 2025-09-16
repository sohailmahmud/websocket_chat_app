import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

class MessageInput extends StatefulWidget {
  final bool enabled;

  const MessageInput({super.key, required this.enabled});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();
  bool _hasText = false;

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty && widget.enabled) {
      context.read<ChatBloc>().add(SendChatMessage(message));
      _messageController.clear();
      setState(() => _hasText = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Row(
          children: [
            // Text field container with emoji/attach/camera icons like WhatsApp
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _messageController,
                  enabled: widget.enabled,
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (v) => setState(() => _hasText = v.trim().isNotEmpty),
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: widget.enabled ? () {} : null,
                      tooltip: 'Emoji',
                      color: widget.enabled ? Colors.grey.shade700 : Colors.grey.shade400,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 22,
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: widget.enabled ? () {} : null,
                          tooltip: 'Attach',
                          color: widget.enabled ? Colors.grey.shade700 : Colors.grey.shade400,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          iconSize: 22,
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.camera_alt_outlined),
                          onPressed: widget.enabled ? () {} : null,
                          tooltip: 'Camera',
                          color: widget.enabled ? Colors.grey.shade700 : Colors.grey.shade400,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          iconSize: 22,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Circular mic or send button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? theme.colorScheme.primary
                    : theme.disabledColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: !widget.enabled
                    ? null
                    : (_hasText ? _sendMessage : () {/* mic pressed */}),
                icon: Icon(_hasText ? Icons.send : Icons.mic),
                color: Colors.white,
                tooltip: _hasText ? 'Send' : 'Voice message',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}