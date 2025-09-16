import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        final isMe = message.sender == 'You';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    // WhatsApp-like colors (light & dark variants)
    final outgoingColor = isDark ? const Color(0xFF005C4B) : const Color(0xFFE7FFDB); // light green
    final incomingColor = isDark ? const Color(0xFF202C33) : Colors.white;
    final bubbleColor = isMe ? outgoingColor : incomingColor;
    final textColor = isDark ? Colors.white : Colors.black87;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(4), // "tail" cut
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(4), // "tail" cut
                            bottomRight: Radius.circular(16),
                          ),
                    border: isMe
                        ? null
                        : Border.all(color: Colors.grey.shade300),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Message text
                      Text(
                        message.content,
                        style: TextStyle(fontSize: 15, color: textColor),
                      ),
                      const SizedBox(height: 4),
                      // Timestamp (and ticks for outgoing) aligned to bottom-right inside bubble
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTimestamp(message.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            _buildStatusIcon(message.status, isDark),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStatusIcon(MessageStatus status, bool isDark) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.white54 : Colors.grey,
            ),
          ),
        );
      case MessageStatus.sent:
        return Icon(Icons.check, size: 16, color: isDark ? Colors.white54 : Colors.grey.shade600);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 16, color: isDark ? Colors.white54 : Colors.grey.shade600);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 16, color: Color(0xFF34B7F1));
    }
  }
}