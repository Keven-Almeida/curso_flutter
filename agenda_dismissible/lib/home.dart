import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _lista = ["keven", "elton", "paloma", "Hanna"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widgets"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _lista.length,
                itemBuilder: (context, index) {
                  final item = _lista[index];
                  return Dismissible(
                    background: Container(
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
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
                    // direction: DismissDirection.vertical,
                    key: Key(item),
                    child: ListTile(
                      title: Text(item),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
