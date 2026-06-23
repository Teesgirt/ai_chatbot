import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/chat_provider.dart';
import 'presentation/screens/chat_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}