import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/utils/colors.dart';
import 'package:provider/provider.dart';

import '../services/sockets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    // TODO: implement initState
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('bands', (data) {
      bands =
          (data as List<dynamic>).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bands');
    super.dispose();
  }

  Widget build(BuildContext context) {
    deletedBand(String id) {
      bands.removeWhere((band) => band.id == id);
      setState(() {});
    }

    SocketService socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands'),
        backgroundColor: GlobalColors.primaryDark,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.online)
                ? const Icon(
                    Icons.check_circle_outline,
                    color: GlobalColors.secondary,
                    size: 25,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: GlobalColors.primaryDanger,
                    size: 25,
                  ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => _listTileWidget(bands[i], deletedBand)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: GlobalColors.primary,
        elevation: 1,
        onPressed: () {
          addNewband();
        },
      ),
    );
  }

  addNewband() {
    final nameBandController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name',
                style: TextStyle(color: GlobalColors.primaryDanger)),
            content: TextField(
              onChanged: (text) {},
              style: const TextStyle(fontSize: 20, color: GlobalColors.primary),
              controller: nameBandController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: GlobalColors.primaryDanger),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              MaterialButton(
                child: const Text(
                  'Add',
                  style: TextStyle(color: GlobalColors.primary),
                ),
                onPressed: () {
                  addBandToList(nameBandController.text);
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('New band name',
                  style: TextStyle(color: GlobalColors.primaryDanger)),
              content: CupertinoTextField(
                onChanged: (text) {},
                style:
                    const TextStyle(fontSize: 20, color: GlobalColors.primary),
                controller: nameBandController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: GlobalColors.primaryDanger),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  isDefaultAction: true,
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Add',
                    style: TextStyle(color: GlobalColors.primary),
                  ),
                  onPressed: () {
                    addBandToList(nameBandController.text);
                  },
                ),
              ],
            );
          });
    }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _listTileWidget(Band band, deleteBand) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
        key: Key(band.id!),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          deleteBand(band.id);
        },
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: GlobalColors.primaryDanger,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name!.substring(0, 2)),
            backgroundColor: GlobalColors.primary,
          ),
          title: Text(band.name!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
            '${band.votes}',
            style: const TextStyle(
                fontSize: 20, color: GlobalColors.primaryDanger),
          ),
          onTap: () {
            socketService.socket.emit('vote', {'id': band.id});
          },
        ));
  }
}
