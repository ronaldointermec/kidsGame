import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/mobile.dart';
import 'package:game/avatar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/ranking.dart';
import 'package:game/sharedPreferencesHelper.dart';
import 'package:game/timerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 0;
  double y = 0;
  bool isAvatarVisible = true;
  bool gameHasStarted = false;
  int secondsRemaining = 60;
  late Timer timer;
  late Timer timerStartGame;

  FirebaseFirestore db = FirebaseFirestore.instance;

  void startTimer() {
    if (gameHasStarted) hideBear();
    startGame();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          stopGame();
          // Stop the timer when it reaches 0
        }
      });
    });
  }

  void startGame() {
    timerStartGame = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!gameHasStarted) {
          stopGame();
        } else {
          moveBear();
        }
      });
    });
  }

  void moveBear() {
    isAvatarVisible = true;
    Random random = Random();
    x = -1 + random.nextDouble() * 2;
    y = -1 + random.nextDouble() * 2;
  }

  void hideBear() {
    setState(() {
      db.collection('score').snapshots().listen((event) {
        setState(() {
          isAvatarVisible = false;

        });
      });
    });
  }

  void deleteAllScores() async {
    final CollectionReference collectionReference = db.collection('score');

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      await queryDocumentSnapshot.reference.delete();
    }
  }

  void stopGame() {
    timerStartGame.cancel();
    timer.cancel();
    setState(() {
      secondsRemaining = 60;
      gameHasStarted = false;
      isAvatarVisible = false;
      x = 0;
      y = 0;
    });
  }

  @override
  void initState() {
    // hideBear();
    // startGame();
    isAvatarVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    timerStartGame.cancel();
    super.dispose();
  }


  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                deleteAllScores();
                Navigator.of(context).pop();
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? GestureDetector(
      onTap: (){
        // gameHasStarted = true;
        // startTimer();
      },
          child: RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                  setState(() {
                    stopGame();
                  });
                } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  gameHasStarted = true;
                  startTimer();
                } else if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
                  //deleteAllScores();
                  _showDialog(context, "Confirmação", "Deseja excluir todos os pontos?" );
                }
              },
              child: Scaffold(
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
                        ConverScreen(
                          gameHasStarted: gameHasStarted,
                        ),
                        TimerScreen(
                          gameHasStarted: gameHasStarted,
                          timerCount:
                              '${(secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}',
                        ),
                        Ranking(),
                        Avatar(
                          x: x,
                          y: y,
                          visible: isAvatarVisible,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        )
        : Mobile();
  }
}
