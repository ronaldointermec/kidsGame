import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore db = FirebaseFirestore.instance;

  // recupera todos os documentos e refaz a consulta a cada novo registro
  db.collection("users").snapshots().listen((snapshot) {
    for (DocumentSnapshot doc in snapshot.docs) {
      print(doc.data());
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
