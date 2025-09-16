import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/websocket_client.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final WebSocketClient webSocketClient;
  StreamController<Either<Failure, Message>>? _messageStreamController;

  ChatRepositoryImpl({required this.webSocketClient});

  @override
  Stream<Either<Failure, Message>> get messageStream =>
      _messageStreamController?.stream ?? const Stream.empty();

  @override
  bool get isConnected => webSocketClient.isConnected;

  @override
  Future<Either<Failure, void>> connect(String url) async {
    try {
      _messageStreamController = StreamController<Either<Failure, Message>>.broadcast();
      
      await webSocketClient.connect(url);
      
      webSocketClient.messageStream.listen(
        (data) {
          try {
            final message = MessageModel.fromString(data.toString());
            _messageStreamController?.add(Right(message));
          } catch (e) {
            _messageStreamController?.add(Left(WebSocketFailure('Failed to parse message: $e')));
          }
        },
        onError: (error) {
          _messageStreamController?.add(Left(WebSocketFailure('WebSocket error: $error')));
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(ConnectionFailure('Failed to connect: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await webSocketClient.disconnect();
      await _messageStreamController?.close();
      _messageStreamController = null;
      return const Right(null);
    } catch (e) {
      return Left(WebSocketFailure('Failed to disconnect: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String message) async {
    try {
      if (!webSocketClient.isConnected) {
        return const Left(WebSocketFailure('Not connected to WebSocket'));
      }
      
      webSocketClient.sendMessage(message);
      return const Right(null);
    } catch (e) {
      return Left(WebSocketFailure('Failed to send message: $e'));
    }
  }
}