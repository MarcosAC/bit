import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IAService {
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<String> sendMessage(String message) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception('Chave API do Gemini não encontrada no arquivo .env');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',          
        },
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text': 'Instrução primordial para você: Você é um robô assistente físico com uma tela de expressões. Seja muito curto, direto, amigável e responda apenas em texto limpo para o sintetizador de voz, sem tópicos, asteriscos ou formatações de markdown.\n\nPergunta do usuário: $message'
                }
              ]
            }
          ],          
          'tools': [
            {
              'googleSearch': {}
            }
          ],
          'generationConfig': {
            'temperature': 0.3,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final candidates = data['candidates'];
        if (candidates == null || candidates.isEmpty) {
          return "Não consegui dados atualizados agora.";
        }

        final content = candidates[0]['content'];
        if (content == null || content['parts'] == null || content['parts'].isEmpty) {
          return "Desculpe, o sistema de busca falhou.";
        }

        String textResponse = content['parts'][0]['text'].toString().trim();

        // Limpeza profunda contra qualquer lixo de formatação da web para não quebrar o seu flutter_tts
        textResponse = textResponse.replaceAll(RegExp(r'\[\d+\]|\[source\]'), ''); 
        textResponse = textResponse.replaceAll('*', ''); 
        textResponse = textResponse.replaceAll(RegExp(r'https?:\/\/\S+'), ''); 
        textResponse = textResponse.replaceAll(RegExp(r'[#_`~]'), ''); 
        textResponse = textResponse.replaceAll(RegExp(r'\s+'), ' ').trim(); 
        
        return textResponse;
      } else {
        debugPrint('Erro HTTP Gemini: ${response.statusCode} - ${response.body}');
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exceção capturada no IAService: $e');
      throw Exception('Falha na comunicação com o robô: $e');
    }
  }
}