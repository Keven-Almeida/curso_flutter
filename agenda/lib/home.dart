import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  Map<String, dynamic> _ultimoaTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizado"] = false;

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  // ignore: unused_element
  _salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  Widget criarItemList(context, index) {
    return Dismissible(
      key: Key(
        DateTime.now().millisecondsSinceEpoch.toString(),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _ultimoaTarefaRemovida = _listaTarefas[index];

        _listaTarefas.remove(index);
        _salvarArquivo();

        final snackbar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text("Texto removido"),
          // backgroundColor: Colors.green,
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _listaTarefas.insert(index, _ultimoaTarefaRemovida);
                  _salvarArquivo();
                });
              }),
        );
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: CheckboxListTile(
          title: Text(_listaTarefas[index]["titulo"]),
          value: _listaTarefas[index]["realizado"],
          onChanged: (valorAlterado) {
            setState(() {
              _listaTarefas[index]["realizado"] = valorAlterado;
            });
            _salvarArquivo();
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) => {
          setState(() {
            _listaTarefas = json.decode(dados);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    // _salvarArquivo();
    print("list: " + _listaTarefas.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Lista de Tarefas"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listaTarefas.length,
              itemBuilder: criarItemList,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua Tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        _salvarTarefa();
                        Navigator.pop(context);
                      },
                      child: Text("Salvar"),
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
