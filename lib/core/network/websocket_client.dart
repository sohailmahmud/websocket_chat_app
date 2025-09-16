import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

abstract class WebSocketClient {
  Stream<dynamic> get messageStream;
  void sendMessage(String message);
  Future<void> connect(String url);
  Future<void> disconnect();
  bool get isConnected;
}

class WebSocketClientImpl implements WebSocketClient {
  WebSocketChannel? _channel;
  StreamController<dynamic>? _messageController;
  bool _isConnected = false;

  @override
  Stream<dynamic> get messageStream => 
      _messageController?.stream ?? const Stream.empty();

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect(String url) async {
    try {
      _messageController = StreamController<dynamic>.broadcast();
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      _channel!.stream.listen(
        (data) {
          _messageController?.add(data);
        },
        onError: (error) {
          _messageController?.addError(error);
          _isConnected = false;
        },
        onDone: () {
          _isConnected = false;
        },
      );
      
      _isConnected = true;
    } catch (e) {
      _isConnected = false;
      throw Exception('Failed to connect: $e');
    }
  }

  @override
  void sendMessage(String message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(message);
    }
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    await _channel?.sink.close(status.goingAway);
    await _messageController?.close();
    _channel = null;
    _messageController = null;
  }
}