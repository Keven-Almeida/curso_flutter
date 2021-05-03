import 'package:flutter/material.dart';
import 'package:whatsapp/cadastro.dart';
import 'package:whatsapp/configuracoes/config_widget.dart';
import 'package:whatsapp/home.dart';
import 'package:whatsapp/login.dart';
import 'package:whatsapp/mensagens/Mensagens.dart';

class RouteGenerator {
  static const String ROTA_HOME = "/home";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CADASTRO = "/cadastro";
  static const String ROTA_CONFIG = "/configuracoes/config_widget";
  static const String ROTA_MENSAGENS = "/mensagens/Mensagens";

  // ignore: missing_return
  static Route<dynamic> genereteRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ROTA_LOGIN:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case ROTA_LOGIN:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case ROTA_CADASTRO:
        return MaterialPageRoute(builder: (_) => Cadastro());
      case ROTA_HOME:
        return MaterialPageRoute(builder: (_) => HomePage());
      case ROTA_CONFIG:
        return MaterialPageRoute(builder: (_) => ConfigWidget());
      case ROTA_MENSAGENS:
        return MaterialPageRoute(builder: (_) => Mensagens(args));
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
