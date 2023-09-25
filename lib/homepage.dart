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
import 'package:shared_preferences/shared_preferences.dart';

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
  FirebaseFirestore db = FirebaseFirestore.instance;

  void startGame() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!gameHasStarted) {
          // timer.cancel();
          //
          stopGame();
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
      db.collection('score').snapshots().listen((event) {
        setState(() {
          visible = false;
          startGame();
          gameHasStarted = true;
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
    setState(() {
      gameHasStarted = false;
      x = 0;
      y = 0;
    });
  }

  @override
  void initState() {
    hideBear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                gameHasStarted = true;
                startGame();
              } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                setState(() {
                  stopGame();
                });
              } else if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
                deleteAllScores();
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
                      Avatar(
                        x: x,
                        y: y,
                        visible: visible,
                      ),
                      Positioned(bottom: 0, right: 0, child: Ranking())
                    ],
                  ),
                ),
              ),
            ),
          )
        : Mobile();
  }
}
