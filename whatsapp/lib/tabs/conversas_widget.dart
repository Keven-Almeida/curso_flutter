import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/conversa_model.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/routes/routes.dart';

class ConversasWidget extends StatefulWidget {
  ConversasWidget({Key key}) : super(key: key);

  @override
  _ConversasWidgetState createState() => _ConversasWidgetState();
}

class _ConversasWidgetState extends State<ConversasWidget> {
  List<ConversaModel> listaConversas = [];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String idUsuarioLogado;
  String idDestinatario;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    // _adicionarListenerConversas();

    ConversaModel conversa = ConversaModel();
    conversa.nome = "Ana Clara";
    conversa.mensagem = "me manda o nome da serie";
    conversa.photoUrl =
        "https://firebasestorage.googleapis.com/v0/b/whasappflutter.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=d29d96d3-244f-4bce-88e5-f272d56b6ad1";

    listaConversas.add(conversa);
  }

  Stream<QuerySnapshot> _adicionarListenerConversas() {
    final stream = db
        .collection("conversas")
        .doc(idUsuarioLogado)
        .collection("ultima_conversa")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarDadosUsuario() {
    User auth = FirebaseAuth.instance.currentUser;
    idUsuarioLogado = auth.uid;

    _adicionarListenerConversas();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando conversas"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados!");
              } else {
                QuerySnapshot querySnapshot = snapshot.data;

                if (querySnapshot.docs.length == 0) {
                  return Center(
                    child: Text(
                      "Você não tem nenhuma mensagem ainda :(",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: listaConversas.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<DocumentSnapshot> conversas =
                        querySnapshot.docs.toList();
                    DocumentSnapshot item = conversas[index];

                    String urlImagem = item["photoUrl"];
                    String tipo = item["tipoMensagem"];
                    String mensagem = item["mensagem"];
                    String nome = item["nome"];
                    String idDestinatario = item["idDestinatario"];

                    UserModel usuario = UserModel();
                    usuario.nome = nome;
                    usuario.urlImagem = urlImagem;
                    usuario.idUsuario = idDestinatario;

                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteGenerator.ROTA_MENSAGENS,
                          arguments: usuario,
                        );
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            urlImagem != null ? NetworkImage(urlImagem) : null,
                      ),
                      title: Text(
                        nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        tipo == "texto" ? mensagem : "Imagem...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                );
              }
          }
        });
  }
}
