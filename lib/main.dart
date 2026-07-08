import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/robot_screen.dart';

Future<void> main() async {
  // Garanti a inicialização dos bindings do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregua o arquivo .env
  await dotenv.load(fileName: ".env");

  runApp(const RobotAIApp());
}

class RobotAIApp extends StatelessWidget {
  const RobotAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bit AI Robot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff121212),
      ),
      home: const RobotScreen(),
    );
  }
}