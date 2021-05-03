import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/routes/routes.dart';

class ContatosWidget extends StatefulWidget {
  @override
  _ContatosWidgetState createState() => _ContatosWidgetState();
}

class _ContatosWidgetState extends State<ContatosWidget> {
  String idUsuarioLogado;
  String userEmail;

  Future<List<UserModel>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("usuarios").get();

    List<UserModel> listaUsers = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data();
      if (dados["email"] == userEmail) continue;

      UserModel user = UserModel();
      user.idUsuario = item.id;
      user.email = dados["email"];
      user.nome = dados["nome"];
      user.urlImagem = dados["urlImagem"];

      listaUsers.add(user);
    }
    return listaUsers;
  }

  _recuperaDadosUser() async {
    // ignore: await_only_futures
    User auth = await FirebaseAuth.instance.currentUser;
    idUsuarioLogado = auth.uid;
    userEmail = auth.email;
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
    return FutureBuilder<List<UserModel>>(
        future: _recuperarContatos(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando contatos"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext _, int index) {
                  List<UserModel> listaItens = snapshot.data;
                  UserModel user = listaItens[index];

                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteGenerator.ROTA_MENSAGENS,
                        arguments: user,
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.urlImagem != null
                            ? NetworkImage(user.urlImagem)
                            : null),
                    title: Text(
                      user.nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              );
              break;
            default:
          }
        });
  }
}
