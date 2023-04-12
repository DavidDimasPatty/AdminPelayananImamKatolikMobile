import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/view/gereja/addGereja.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Agen/Message.dart';
import '../../Agen/MessagePassing.dart';
import '../../Agen/Task.dart';

class DaftarGereja extends StatefulWidget {
  final id;
  DaftarGereja(this.id);
  @override
  _DaftarGereja createState() => _DaftarGereja(this.id);
}

class _DaftarGereja extends State<DaftarGereja> {
  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;
  bool isLoading = true;
  List dummyTemp = [];

  final id;
  _DaftarGereja(this.id);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari gereja', null));

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
        if (item['nama']
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

  Future updateGereja(idGereja, status) async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
        Tasks('update gereja', [idGereja, status]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilDaftar = await AgentPage.getDataPencarian();

    completer.complete();

    await completer.future;
    if (hasilDaftar == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Banned Gereja",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Banned Gereja",
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          data = data + 5;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Daftar Gereja'),
      ),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: AnimSearchBar(
                autoFocus: false,
                width: 400,
                rtl: true,
                helpText: 'Cari Gereja',
                textController: editingController,
                onSuffixTap: () {
                  setState(() {
                    editingController.clear();
                  });
                },
                onSubmitted: (String) {},
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addGereja(id)),
                        );
                      },
                      splashColor: Colors.blue,
                      splashRadius: 30,
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
                Text("Add Gereja")
              ],
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
                      for (var i in hasil.take(data))
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           KrismaUser(names, idUser, idGereja, i['_id'])),
                            // );
                          },
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
                                //Color(Colors.blue);

                                Text(
                                  "Nama: " + i['nama'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Paroki: ' + i['paroki'].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  'Address: ' + i['address'].toString(),
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
                                        child: Text("Banned Gereja"),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () async {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title:
                                                  const Text('Confirm Banned'),
                                              content: const Text(
                                                  'Yakin ingin ban Gereja ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await updateGereja(
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
                                        child: Text("Unbanned Gereja"),
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
                                                  'Yakin ingin Unbanned Gereja ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await updateGereja(
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
                        )
                    ]);
                  } catch (e) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // return Center(child: CircularProgressIndicator());
                }),

            /////////
          ],
        ),
      ),
    );
  }
}
