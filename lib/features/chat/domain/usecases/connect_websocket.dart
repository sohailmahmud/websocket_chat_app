import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class ConnectWebSocket implements UseCase<void, ConnectParams> {
  final ChatRepository repository;

  ConnectWebSocket(this.repository);

  @override
  Future<Either<Failure, void>> call(ConnectParams params) async {
    return await repository.connect(params.url);
  }
}

class ConnectParams {
  final String url;
  ConnectParams({required this.url});
}