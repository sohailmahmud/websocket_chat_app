import 'package:get_it/get_it.dart';
import 'core/network/websocket_client.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/connect_websocket.dart';
import 'features/chat/domain/usecases/disconnect_websocket.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => ChatBloc(
      connectWebSocket: sl(),
      disconnectWebSocket: sl(),
      sendMessage: sl(),
      chatRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ConnectWebSocket(sl()));
  sl.registerLazySingleton(() => DisconnectWebSocket(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(webSocketClient: sl()),
  );

  // External
  sl.registerLazySingleton<WebSocketClient>(() => WebSocketClientImpl());
}