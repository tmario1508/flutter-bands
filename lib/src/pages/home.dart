import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/utils/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 0),
    Band(id: '2', name: 'Iron Maiden', votes: 4),
    Band(id: '3', name: 'Rammstein', votes: 2),
    Band(id: '4', name: 'Heroes del Silencio', votes: 8),
  ];

  Widget build(BuildContext context) {
    deletedBand(String id) {
      bands.removeWhere((band) => band.id == id);
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands'),
        backgroundColor: GlobalColors.primaryDark,
        elevation: 1,
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
      bands.add(Band(id: (bands.length + 1).toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}

Widget _listTileWidget(Band band, deleteBand) {
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
          style:
              const TextStyle(fontSize: 20, color: GlobalColors.primaryDanger),
        ),
        onTap: () {
          print(band.name);
        },
      ));
}