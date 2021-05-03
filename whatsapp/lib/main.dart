import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/login.dart';
import 'package:whatsapp/routes/routes.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff075e54),
  accentColor: Color(0xff25D366),
);

final ThemeData temaIos = ThemeData(
  primaryColor: Colors.grey[200],
  accentColor: Color(0xff25D366),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      home: LoginPage(),
      theme: Platform.isIOS ? temaIos : temaPadrao,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      // ignore: missing_return
      onGenerateRoute: RouteGenerator.genereteRoute,
    ),
  );
}
