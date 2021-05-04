import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_flutter/api.dart';
import 'package:youtube_flutter/models/video.dart';

// ignore: must_be_immutable
class Inicio extends StatefulWidget {
  String pesquisa;
  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  _listarVideos(String pesquisa) {
    Api api = Api();
    return api.pesquisar(pesquisa);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: _listarVideos(widget.pesquisa),
      // ignore: missing_return
      builder: (contex, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    List<Video> videos = snapshot.data;
                    Video video = videos[index];

                    return GestureDetector(
                      onTap: () {
                        FlutterYoutube.playYoutubeVideoById(
                            apiKey: CHAVE_YOUTUBE_API,
                            videoId: video.id,
                            autoPlay: true);
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(video.imagem),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(video.titulo),
                            subtitle: Text(video.canal),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        height: 2,
                        color: Colors.red[900],
                      ),
                  itemCount: snapshot.data.length);
            } else {
              return Center(
                child: Text("Nenhum dado a ser exibido"),
              );
            }
            break;
          default:
        }
      },
    );
  }
}
