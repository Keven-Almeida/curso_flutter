import 'package:flutter/material.dart';
import 'package:youtube_flutter/telas/EmAlta.dart';
import 'package:youtube_flutter/telas/biblioteca.dart';
import 'package:youtube_flutter/telas/inicio.dart';
import 'package:youtube_flutter/telas/inscricao.dart';

import 'CustomSearchDelegate.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _indiceAtual = 0;
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      Inicio(_resultado),
      EmAlta(),
      Inscricao(),
      Biblioteca(),
    ];
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.grey[400]),
        title: Image.asset(
          "images/youtube.png",
          width: 98,
          height: 22,
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.videocam),
          //   onPressed: () {
          //     print("acao: VideoCam");
          //   },
          // ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String res = await showSearch(
                    context: context, delegate: CustomSearchDelegate());
                setState(() {
                  _resultado = res;
                });
              }),
          // IconButton(
          //     icon: Icon(Icons.account_circle),
          //     onPressed: () {
          //       print("acao: conta");
          //     })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.red[400],
            // ignore: deprecated_member_use
            title: Text("Início"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue[300],
            // ignore: deprecated_member_use
            title: Text("Em alta"),
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo[300],
            // ignore: deprecated_member_use
            title: Text("Inscrições"),
            icon: Icon(Icons.subscriptions),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.cyan[400],
            // ignore: deprecated_member_use
            title: Text("Biblioteca"),
            icon: Icon(Icons.folder),
          )
        ],
      ),
    );
  }
}
