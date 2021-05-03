// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/routes/routes.dart';
import 'package:whatsapp/tabs/conversas_widget.dart';
import 'package:whatsapp/tabs/contatos_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  // ignore: unused_field
  TextEditingController _controllerNome = TextEditingController();
  // ignore: unused_field
  String _urlImagemRecuperada;
  String emailUser;
  List<String> itensMenu = [
    "Configurações",
    "Deslogar",
  ];

  Future _verificaUserLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    User userLogado = await auth.currentUser;

    if (userLogado == null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
    }
  }

  @override
  void initState() {
    super.initState();
    _verificaUserLogado();
    _recuperaDadosUser();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Configurações":
        Navigator.pushNamed(context, RouteGenerator.ROTA_CONFIG);
        break;
      case "Deslogar":
        print("Deslogar");
        _deslogarUser();
        break;
      default:
    } // print("item scolhido " + itemEscolhido);
  }

  _deslogarUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
  }

  Future _recuperaDadosUser() async {
    User auth = FirebaseAuth.instance.currentUser;
    setState(() {
      emailUser = auth.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        elevation: Platform.isIOS ? 0 : 4,
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Platform.isIOS ? Colors.grey[400] : Colors.white,
          tabs: [
            Tab(
              text: "Conversas",
            ),
            Tab(
              text: "Contatos",
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu
                    .map((e) => PopupMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList();
              })
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ConversasWidget(),
          ContatosWidget(),
        ],
      ),
    );
  }
}
