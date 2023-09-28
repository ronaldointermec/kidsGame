import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/sharedPreferencesHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scannerManager.dart';

class Mobile extends StatefulWidget {
  const Mobile({Key? key}) : super(key: key);

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  late ScannerManager scanner;
  bool hideBer = false;
  int score = 0;
  String apelido = '';
  String error = '';
  TextEditingController _controllerNome = TextEditingController();

  void saveScore() {
    if (!apelido.contains('caracters') && apelido != null) {
      FirebaseFirestore.instance
          .collection('score')
          .doc(apelido)
          .set({'nome': apelido, 'ponto': score});
    }
  }

  void validarCampos() {
    // recupera dados do campo
    String nome = _controllerNome.text;

    if (nome.length > 3) {
      setUserName(nome);
      _controllerNome.text = '';
      setState(() {
        error = '';
      });
    } else {
      setState(() {
        error = 'O apelido precisa ter mais de 3 caracters';
      });
    }
  }

  void getUserName() async {
    final preferentes = await SharedPreferences.getInstance();

    final sharedPreferencesHelper = SharedPreferencesHelper(preferentes);

    setState(() {
      apelido = sharedPreferencesHelper.getString('userName');
    });
  }

  void setUserName(String name) async {
    final preferentes = await SharedPreferences.getInstance();

    final sharedPreferencesHelper = SharedPreferencesHelper(preferentes);
    await sharedPreferencesHelper.setString("userName", name);
    score = 0;

    getUserName();
  }

  void _onDecode() {
    scanner.getCode.listen(
      (result) {
        if (result == "QR Code") {
          score = score + 1;
          saveScore();
          setState(() {
            hideBer = !hideBer;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    scanner.dispose();
    super.dispose();
  }

  @override
  void initState() {
    score = 0;
    scanner = ScannerManager();
    getUserName();
    _onDecode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ' + apelido),
        elevation: 0,
        backgroundColor: Color(0xFF075E54),
        actions: [
          CircleAvatar(
            backgroundColor: Color(0xFF075E54),
            child: Text(score.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                score = 0;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/bear.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(error,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'Apelido',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    onPressed: validarCampos,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
