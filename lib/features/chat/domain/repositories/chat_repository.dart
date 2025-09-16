import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> connect(String url);
  Future<Either<Failure, void>> disconnect();
  Stream<Either<Failure, Message>> get messageStream;
  Future<Either<Failure, void>> sendMessage(String message);
  bool get isConnected;
}