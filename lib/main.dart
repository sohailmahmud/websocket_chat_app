import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/widgets/chat_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF075E54)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF075E54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: const Color(0xFFECE5DD),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005C4B),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0B141A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F2C34),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );

    return MaterialApp(
      title: 'WebSocket Chat',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) => BlocProvider(
        create: (_) => di.sl<ChatBloc>(),
        child: child,
      ),
      home: const ChatPage(),
    );
  }
}
