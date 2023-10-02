import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final x;
  final y;
  final visible;

  const Avatar({super.key, this.x, this.y, this.visible});

  @override
  Widget build(BuildContext context) {
    return visible
        ? AnimatedContainer(
            duration: Duration(seconds: 1),
            alignment: Alignment(x, y),
            child: Image.asset(
              "imagens/bear.png",
              width: 300,
              height: 300,
            ),
          )
        : const Center();
  }
}
