import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_flutter/models/video.dart';

const CHAVE_YOUTUBE_API = "AIzaSyDxAgnF-Tim_lafqgz0k7AXctYh1NC5bK8";
const BASE_URL = "https://www.googleapis.com/youtube/v3/";
const CHANNEL_ID = "UCUx2O9MzBt12X2uQgYq7a_g";

class Api {
  // ignore: missing_return
  Future<List<Video>> pesquisar(String pesquisa) async {
    http.Response response = await http.get(Uri.parse(BASE_URL +
        "search"
            "?part=snippet"
            "&type=video"
            "&maxResults=20"
            "&order=date"
            "&key=$CHAVE_YOUTUBE_API"
            "&channelId=$CHANNEL_ID"
            "&q=$pesquisa"));

    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);
      List<Video> videos = dadosJson["items"].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();
      // print(videos);
      return videos;
    } else {}
  }
}
