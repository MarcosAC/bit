import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IAService {
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions'; 
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content': 'Você é um robô assistente físico com uma tela de expressões. Seja curto, direto e amigável.'
            },
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na comunicação com o robô: $e');
    }
  }
}