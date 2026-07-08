import 'package:flutter/material.dart';
import '../data/models/robot_emotion.dart';
import '../data/services/ia_service.dart'; // O seu service que bate na Groq
import '../data/services/voice_service.dart';

class RobotViewModel extends ChangeNotifier {
  final IAService _apiService = IAService();
  final VoiceService _voiceService = VoiceService();

  RobotEmotion _currentEmotion = RobotEmotion.idle;
  String _lastResponse = "Segure o botão para falar comigo!";
  bool _isLoading = false;
  bool _isListening = false;

  RobotEmotion get currentEmotion => _currentEmotion;
  String get lastResponse => _lastResponse;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;

  // Inicializa o serviço de voz na abertura do app
  Future<void> initRobot() async {
    await _voiceService.initVoice();
  }

  void _updateEmotion(RobotEmotion emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  // Ação 1: Quando o usuário pressiona/segura o botão do Microfone
  Future<void> startVoiceCapture() async {
    if (_isLoading) return;

    await _voiceService.stopSpeaking(); // Para de falar se já estava falando
    _isListening = true;
    _updateEmotion(RobotEmotion.listening);

    await _voiceService.startListening((textDetected) {
      _isListening = false;
      // Assim que capturar a frase final, envia automaticamente para a IA
      processRobotResponse(textDetected);
    });
  }

  // Ação 2: Cancela ou para o microfone manualmente
  Future<void> stopVoiceCapture() async {
    _isListening = false;
    await _voiceService.stopListening();
  }

  // Processamento interno da Inteligência Artificial + Resposta por Voz
  Future<void> processRobotResponse(String userText) async {
    if (userText.trim().isEmpty) {
      _updateEmotion(RobotEmotion.idle);
      return;
    }
  
    _isLoading = true;
    _updateEmotion(RobotEmotion.thinking);

    try {
      // 1. Busca a resposta de texto na Groq
      final response = await _apiService.sendMessage(userText);
      _lastResponse = response;

      // 2. Coloca os olhos do robô no modo falante e executa o áudio nativo
      _updateEmotion(RobotEmotion.speaking);
      await _voiceService.speak(response);

      // Retorna ao estado ocioso após o término
      _updateEmotion(RobotEmotion.idle);
    } catch (e) {
      _lastResponse = "Erro no meu sintetizador de voz.";
      _updateEmotion(RobotEmotion.sad);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
