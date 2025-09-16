import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DisconnectWebSocket implements UseCase<void, NoParams> {
  final ChatRepository repository;

  DisconnectWebSocket(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.disconnect();
  }
}