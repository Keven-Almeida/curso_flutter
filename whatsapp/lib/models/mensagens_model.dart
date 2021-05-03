class MensagensModel {
  String _idUsuario;
  String _mensagem;
  String _urlImagem;
  String _tipo;
  String _data;

  MensagensModel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idUsuario': this.idUsuario,
      'mensagem': this.mensagem,
      'urlImagem': this.urlImagem,
      'tipo': this.tipo,
      'data': this.data,
    };
    return map;
  }

  // ignore: unnecessary_getters_setters
  String get idUsuario => _idUsuario;

  // ignore: unnecessary_getters_setters
  set idUsuario(String value) {
    _idUsuario = value;
  }

  // ignore: unnecessary_getters_setters
  String get urlImagem => _urlImagem;

  // ignore: unnecessary_getters_setters
  set urlImagem(String value) {
    _urlImagem = value;
  }

  // ignore: unnecessary_getters_setters
  String get mensagem => _mensagem;

  // ignore: unnecessary_getters_setters
  set mensagem(String value) {
    _mensagem = value;
  }

  // ignore: unnecessary_getters_setters
  String get tipo => _tipo;

  // ignore: unnecessary_getters_setters
  set tipo(String value) {
    _tipo = value;
  }

  // ignore: unnecessary_getters_setters
  String get data => _data;

  // ignore: unnecessary_getters_setters
  set data(String value) {
    _data = value;
  }
}
