import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';
import 'services/chat_repository.dart';
import 'services/gemini_service.dart';
import 'views/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ChatAiApp());
}

class ChatAiApp extends StatelessWidget {
  const ChatAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => GeminiService.fromEnvironment()),
        Provider(create: (_) => ChatRepository()),
        ChangeNotifierProxyProvider2<GeminiService, ChatRepository, ChatProvider>(
          create: (_) => ChatProvider(),
          update: (_, geminiService, chatRepository, provider) =>
              provider!..configure(geminiService, chatRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat AI Pro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
