import 'package:flutter/material.dart';
import '../../data/models/robot_emotion.dart';

class RobotEyes extends StatelessWidget {
  final RobotEmotion emotion;

  const RobotEyes({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildEye(), const SizedBox(width: 40), _buildEye()],
    );
  }

  Widget _buildEye() {
    // Customização geométrica baseada nos displays OLED/IPS de robótica
    switch (emotion) {
      case RobotEmotion.listening:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 45,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.cyanAccent,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      case RobotEmotion.thinking:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      case RobotEmotion.speaking:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(25),
          ),
        );
      case RobotEmotion.sad:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        );
      case RobotEmotion.idle:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.yellowAccent,
            borderRadius: BorderRadius.circular(15),
          ),
        );
    }
  }
}
