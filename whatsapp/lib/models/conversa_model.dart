import 'package:cloud_firestore/cloud_firestore.dart';

class ConversaModel {
  String _idRemetente;
  String _idDestinatario;
  String _nome;
  String _mensagem;
  String _photoUrl;
  String _tipoMensagem;

  ConversaModel();

  salvar() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("conversas")
        .doc(this.idRemetente)
        .collection("ultima_conversa")
        .doc(this.idDestinatario)
        .set(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idRemetente': this.idRemetente,
      'idDestinatario': this.idDestinatario,
      'nome': this.nome,
      'mensagem': this.mensagem,
      'photoUrl': this.photoUrl,
      'tipoMensagem': this.tipoMensagem,
    };
    return map;
  }

  // ignore: unnecessary_getters_setters
  String get photoUrl => _photoUrl;

  // ignore: unnecessary_getters_setters
  set photoUrl(String value) {
    _photoUrl = value;
  }

  // ignore: unnecessary_getters_setters
  String get mensagem => _mensagem;

  // ignore: unnecessary_getters_setters
  set mensagem(String value) {
    _mensagem = value;
  }

  // ignore: unnecessary_getters_setters
  String get nome => _nome;

  // ignore: unnecessary_getters_setters
  set nome(String value) {
    _nome = value;
  }

  // ignore: unnecessary_getters_setters
  String get idRemetente => _idRemetente;

  // ignore: unnecessary_getters_setters
  set idRemetente(String value) {
    _idRemetente = value;
  }

  // ignore: unnecessary_getters_setters
  String get idDestinatario => _idDestinatario;

  // ignore: unnecessary_getters_setters
  set idDestinatario(String value) {
    _idDestinatario = value;
  }

  // ignore: unnecessary_getters_setters
  String get tipoMensagem => _tipoMensagem;

  // ignore: unnecessary_getters_setters
  set tipoMensagem(String value) {
    _tipoMensagem = value;
  }
}
