import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool get isListening => _speechToText.isListening;

  // Inicializa os motores de áudio do sistema operacional
  Future<bool> initVoice() async {
    bool speechAvailable = await _speechToText.initialize();

    // Configurações do Sintetizador de Voz (Robô falando)
    await _flutterTts.setLanguage('pt-BR');
    await _flutterTts.setSpeechRate(0.50); // Velocidade da fala
    await _flutterTts.setVolume(1.0); // Volume da fala
    await _flutterTts.setPitch(0.85); // Tom da fala

    return speechAvailable;
  }

  // Começa a ouvir o microfone e devolve o texto em tempo real via callback
  Future<void> startListening(Function(String) onResult) async {
    if (!_speechToText.isListening) {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          }
        },
        listenOptions: SpeechListenOptions(
          localeId: "pt_BR",
          listenFor: Duration(seconds: 10),
          pauseFor: Duration(seconds: 3),
        ),
      );
    }
  }

  // Para de ouvir o microfone imediatamente
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  // Faz o robô falar o texto recebido
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  // Interrompe a fala do robô caso o usuário queira interrompê-lo
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }  
}
