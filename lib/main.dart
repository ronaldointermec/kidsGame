import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game/firebase_options.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseFirestore db = FirebaseFirestore.instance;
  //
  // // aplicando filtros
  // QuerySnapshot qs = await db
  //     .collection('users')
  //     // .where('nome', isEqualTo: 'jamilton')
  //     // .where('idade', isGreaterThan: 10)
  //     // .where('idade', isLessThan: 44)
  //     // .orderBy('idade', descending: true)
  //     // .limit(1)
  //     .where('nome', isGreaterThanOrEqualTo: 'an')
  //     .where('nome', isLessThanOrEqualTo: 'an' + '\uf8ff')
  //     .get();
  //
  // for (DocumentSnapshot item in qs.docs) {
  //   Map<String, dynamic> data = item.data() as Map<String, dynamic>;
  //   print('Nome: ${data['nome']} \nIdade: ${data['idade']}');
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Snackbar with Get',
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Color(0xff075E54),
        // primaryColorLight: Color(0xff25D366),
        // primaryColorDark: Color(0xff25D366),
        // canvasColor: Color(0xff25D366),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
