import 'package:flutter/material.dart';
import '../viewmodels/robot_viewmodel.dart';
import 'widgets/robot_eyes.dart';

class RobotScreen extends StatefulWidget {
  const RobotScreen({super.key});

  @override
  State<RobotScreen> createState() => _RobotScreenState();
}

class _RobotScreenState extends State<RobotScreen> {
  final RobotViewModel _viewModel = RobotViewModel();
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escuta as mudanças vindo da ViewModel (Reatividade NanoMVVM)
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212), // Simula a tela desligada/Hardware
      appBar: AppBar(
        title: const Text('ESP32-S3 AI Robot Face', style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            
            // Área do Display do Hardware (Expressão dos Olhos)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade900, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.05),
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ]
              ),
              child: Center(
                child: RobotEyes(emotion: _viewModel.currentEmotion),
              ),
            ),

            // Balão de resposta do console da IA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _viewModel.lastResponse,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'monospace', // Estilo terminal/hardware
                ),
              ),
            ),

            // Input / Painel de Controle de Envio de Voz/Texto
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Diga algo para o robô...",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xff1e1e1e),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      _viewModel.processVoiceInput(_inputController.text);
                      _inputController.clear();
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: _viewModel.isLoading ? Colors.grey : Colors.cyanAccent,
                      child: Icon(
                        _viewModel.isLoading ? Icons.hourglass_bottom : Icons.mic,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}