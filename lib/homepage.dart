import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/ScannerManager.dart';
import 'package:game/qrcode.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 0;
  double y = 0;
  bool visible = true;
  bool gameHasStarted = false;
  late ScannerManager scanner;
  int score = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Future<String> getScore() async {
  //   await db.collection("score").snapshots().listen((snapshot) {
  //     for (DocumentSnapshot doc in snapshot.docs) {
  //       var score = doc.data();
  //       return ""+score;
  //     }
  //   });
  // }

  void startGame() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!gameHasStarted) {
          timer.cancel();
        } else {
          moveBear();
        }
      });
    });
  }

  void moveBear() {
    visible = true;
    Random random = Random();
    x = -1 + random.nextDouble() * 2;
    y = -1 + random.nextDouble() * 2;
  }

  void hideBear() {
    setState(() {
      visible = false;
    });
  }

  void resetGame() {
    setState(() {
      x = 0;
      y = 0;
    });
  }

  void _onDecode() {
    scanner.getCode.listen(
      (result) {
        score++;

        print('################################### ${result}');
        setState(
          () {},
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      scanner = ScannerManager();
      _onDecode();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      scanner.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                hideBear();
              } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                setState(() {
                  gameHasStarted = !gameHasStarted;
                });
                if (gameHasStarted)
                  startGame();
                else
                  resetGame();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.grey[900],
              body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("imagens/background.jpg"),
                  fit: BoxFit.cover,
                )),
                child: Center(
                  child: Stack(
                    // alignment: Alignment.center,
                    children: [
                      QRCode(
                        x: x,
                        y: y,
                        visible: visible,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: TextButton(
              child: const Text(
                'salvar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                db
                    .collection('score')
                    .doc('001')
                    .set({'Name': 'Ronaldo', 'ponto': this.score});
              },
            ),
          );
  }
}
