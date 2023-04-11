import 'dart:async';
import 'dart:io';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DaftarUser extends StatefulWidget {
  final id;
  DaftarUser(this.id);
  @override
  _DaftarUser createState() => _DaftarUser(this.id);
}

class _DaftarUser extends State<DaftarUser> {
  List hasil = [];
  StreamController _controller = StreamController();

  List dummyTemp = [];

  final id;
  _DaftarUser(this.id);

  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari user', null));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilPencarian = await AgentPage.getDataPencarian();

    completer.complete();

    await completer.future;
    return await hasilPencarian;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        hasil.clear();
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        hasil.clear();
        hasil.addAll(listOMaps);
      });
    } else {
      setState(() {
        hasil.clear();
        hasil.addAll(dummyTemp);
      });
    }
  }

  Future updateUser(idUser, status) async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
        Tasks('update user', [idUser, status]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilDaftar = await AgentPage.getDataPencarian();

    completer.complete();

    await completer.future;

    if (hasilDaftar == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal Banned User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (hasilDaftar == "oke") {
      Fluttertoast.showToast(
          msg: "Berhasil Banned User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      callDb().then((result) {
        setState(() {
          hasil.clear();
          dummyTemp.clear();
          hasil.addAll(result);
          dummyTemp.addAll(result);
          _controller.add(result);
        });
      });
    }
  }

  Future pullRefresh() async {
    callDb().then((result) {
      setState(() {
        hasil.clear();
        dummyTemp.clear();
        hasil.clear();
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    editingController.addListener(() async {
      await filterSearchResults(editingController.text);
    });
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text('Daftar User'),
        ),
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(right: 15, left: 15),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: AnimSearchBar(
                  autoFocus: false,
                  width: 400,
                  rtl: true,
                  helpText: 'Cari User',
                  textController: editingController,
                  onSuffixTap: () {
                    setState(() {
                      editingController.clear();
                    });
                  },
                  onSubmitted: (String) {},
                ),
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              /////////
              StreamBuilder(
                  stream: _controller.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    try {
                      return Column(children: [
                        for (var i in hasil)
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {},
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: 15, left: 15, bottom: 20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Colors.blueGrey,
                                        Colors.lightBlue,
                                      ]),
                                  border: Border.all(
                                    color: Colors.lightBlue,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(children: <Widget>[
                                  Text(
                                    "Nama :" + i['name'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Tanggal Daftar: ' +
                                        i['tanggalDaftar']
                                            .toString()
                                            .substring(0, 10),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  if (i['banned'] == 0)
                                    Text(
                                      'Banned: No',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  if (i['banned'] == 1)
                                    Text(
                                      'Banned: Yes',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  if (i['banned'] == 0)
                                    SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lightBlue,
                                          child: Text("Banned User"),
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          onPressed: () async {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Confirm Banned'),
                                                content: const Text(
                                                    'Yakin ingin ban user ini?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Tidak'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await updateUser(
                                                          i["_id"], 1);

                                                      Navigator.pop(context);
                                                      setState(() {
                                                        callDb()
                                                            .then((result) {});
                                                      });
                                                    },
                                                    child: const Text('Ya'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  if (i['banned'] == 1)
                                    SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lightBlue,
                                          child: Text("Unbanned User"),
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          onPressed: () async {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Confirm Unbanned'),
                                                content: const Text(
                                                    'Yakin ingin Unbanned user ini?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Tidak'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await updateUser(
                                                          i["_id"], 0);
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        callDb()
                                                            .then((result) {});
                                                      });
                                                    },
                                                    child: const Text('Ya'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                ])),
                          ),
                      ]);
                    } catch (e) {
                      print(e);

                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              /////////
            ],
          ),
        ));
  }
}
