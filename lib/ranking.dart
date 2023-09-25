import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

  final Stream<QuerySnapshot> _scoreStream = FirebaseFirestore.instance
      .collection('score')
      .orderBy('ponto', descending: true)
      .limit(20)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      width: 300,
      height: 800,
      child: StreamBuilder<QuerySnapshot>(
        stream: _scoreStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  data['nome'] + ' : ' + data['ponto'].toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                // subtitle: Text(
                //   data['ponto'].toString(),
                //   style: TextStyle(color: Colors.white, fontSize: 20),
                // ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// class Score {
//   String _nome = '';
//   int _ponto = 0;
//
//   Score();
//
//   int get ponto => _ponto;
//
//   set ponto(int value) {
//     _ponto = value;
//   }
//
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = {
//       "nome": this.nome,
//       "ponto": this._ponto
//     };
//     return map;
//   }
//
//   String get nome => _nome;
//
//   set nome(String value) {
//     _nome = value;
//   }
// }
