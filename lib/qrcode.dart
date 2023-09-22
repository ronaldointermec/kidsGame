import 'package:flutter/material.dart';

class QRCode extends StatelessWidget {
  final x;
  final y;
  final visible;

  const QRCode({super.key, this.x, this.y, this.visible});

  @override
  Widget build(BuildContext context) {
    return visible
        ? AnimatedContainer(
            duration: Duration(seconds: 2),
            alignment: Alignment(x, y),
            child: Image.asset(
              "imagens/bear.png",
              width: 400,
              height: 400,
            ),
          )
        : const Center();
  }
}
