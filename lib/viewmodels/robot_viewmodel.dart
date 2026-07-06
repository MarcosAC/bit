import 'package:flutter/material.dart';
import '../data/models/robot_emotion.dart';
import '../data/services/ia_service.dart';

class RobotViewModel extends ChangeNotifier {
  final IAService _iaService = IAService();

  // Estados internos
  RobotEmotion _currentEmotion = RobotEmotion.idle;
  String _lastResponse = "Olá! Toque no microfone para falar comigo.";
  bool _isLoading = false;

  // Getters públicos (Imutabilidade para a View)
  RobotEmotion get currentEmotion => _currentEmotion;
  String get lastResponse => _lastResponse;
  bool get isLoading => _isLoading;

  // Atualiza a emoção e notifica a View imediatamente
  void _updateEmotion(RobotEmotion emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  // Ação disparada pelo usuário na View
  Future<void> processVoiceInput(String userText) async {
    if (userText.trim().isEmpty || _isLoading) return;

    _isLoading = true;
    _updateEmotion(RobotEmotion.listening);
    
    // Simula o tempo de transição enquanto ouve/processa
    await Future.delayed(const Duration(milliseconds: 800));
    _updateEmotion(RobotEmotion.thinking);

    try {
      final response = await _iaService.sendMessage(userText);
      _lastResponse = response;
      _updateEmotion(RobotEmotion.speaking);
      
      // Retorna ao estado ocioso (idle) após "falar"
      Future.delayed(const Duration(seconds: 5), () {
        if (_currentEmotion == RobotEmotion.speaking) {
          _updateEmotion(RobotEmotion.idle);
        }
      });
    } catch (e) {
      _lastResponse = "Ops! Meu sistema falhou. Verifique minha conexão.";
      _updateEmotion(RobotEmotion.sad);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}