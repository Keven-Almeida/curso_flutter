import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConfigWidget extends StatefulWidget {
  @override
  _ConfigWidgetState createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  String userId;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  // ignore: missing_return
  Future _recuperarImagem(String origemImagem) async {
    PickedFile imagemSelecionada;

    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
            // ignore: invalid_use_of_visible_for_testing_member
            await ImagePicker.platform.pickImage(source: ImageSource.camera);

        break;
      case "galeria":
        imagemSelecionada =
            // ignore: invalid_use_of_visible_for_testing_member
            await ImagePicker.platform.pickImage(source: ImageSource.gallery);

        break;
    }
    setState(() {
      _imagem = File(imagemSelecionada.path);
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  // ignore: missing_return
  Future _uploadImagem() {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("perfil").child(userId + ".jpg");

    UploadTask task = arquivo.putFile(_imagem);

    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      // ignore: unrelated_type_equality_checks
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        _recuperarUrlImagem(storageEvent);
        setState(() {
          _subindoImagem = false;
        });
      }
    });
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    _atualizarUrlImagem(url);
    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarNome() {
    String nome = _controllerNome.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosUpdate = {"nome": nome};
    db.collection("usuarios").doc(userId).update(dadosUpdate);
  }

  _atualizarUrlImagem(String url) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosUpdate = {"urlImagem": url};
    db.collection("usuarios").doc(userId).update(dadosUpdate);
  }

  _recuperaDadosUser() async {
    User auth = FirebaseAuth.instance.currentUser;
    userId = auth.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(userId).get();
    Map<String, dynamic> dados = snapshot.data();
    _controllerNome.text = dados["nome"];
    if (dados["urlImagem"] != null) {
      _urlImagemRecuperada = dados["urlImagem"];
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cofigurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _subindoImagem
                      ? CircularProgressIndicator()
                      : Container()),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage: _urlImagemRecuperada != null
                    ? NetworkImage(_urlImagemRecuperada)
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        _recuperarImagem("camera");
                      },
                      child: Text("Câmera")),
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        _recuperarImagem("galeria");
                      },
                      child: Text("Galeria"))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllerNome,
                  autofocus: true,
                  keyboardType: TextInputType.name,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: _atualizarNome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
