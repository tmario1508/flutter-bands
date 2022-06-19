import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  Socket? _socket;
  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket!;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = io(
        'http://192.168.2.10:3005',
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());
    _socket!.onConnect((_) {
      print('conectado');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket!.onDisconnect((_) {
      print('desconectado');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
