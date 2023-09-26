import 'package:flutter/material.dart';

class ConverScreen extends StatelessWidget {
  final bool gameHasStarted;

  const ConverScreen({super.key, required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.2),
      child: Text(
        gameHasStarted ? "" : 'C L I Q U E  P A R A  J O G A R',
        style: TextStyle(color: Colors.white, fontSize: 50),
      ),
    );
  }
}
