import 'package:band_names/src/services/sockets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/pages/home.dart';
import 'package:band_names/src/pages/status.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'status',
        routes: {
          'home': (_) => HomePage(),
          'status': (_) => StatusPage(),
        },
      ),
    );
  }
}