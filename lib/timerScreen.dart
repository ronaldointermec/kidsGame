import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  final bool gameHasStarted;
  final timerCount;

  // final playerScore;

  const TimerScreen({
    super.key,
    required this.gameHasStarted,
    required this.timerCount,
    /*required this.playerScore*/
  });

  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Container(
            alignment: Alignment(0.99, -0.99),
            child: Text(
              timerCount.toString(),
              style: TextStyle(color: Colors.amber, fontSize: 100),
            ),
          )
        : Container();
  }
}
