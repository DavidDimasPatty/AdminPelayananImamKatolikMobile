import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/view/Peran/addPeran.dart';

import 'package:admin_pelayanan_katolik/view/imam/addImam.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DaftarPeran extends StatefulWidget {
  final id;
  String peran;
  DaftarPeran(this.id, this.peran);
  @override
  _DaftarPeran createState() => _DaftarPeran(this.id, this.peran);
}

class _DaftarPeran extends State<DaftarPeran> {
  List hasil = [];
  String peran;
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;
  List dummyTemp = [];
  final id;
  _DaftarPeran(this.id, this.peran);

  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari ' + peran, null));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilPencarian = await AgentPage.getData();

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

  Future updatePeran(idPeran, status) async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
        Tasks('update ' + peran, [idPeran, status]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilDaftar = await AgentPage.getData();

    completer.complete();

    await completer.future;

    if (hasilDaftar == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal Banned " + peran,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (hasilDaftar == "oke") {
      Fluttertoast.showToast(
          msg: "Berhasil Banned " + peran,
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
          hasil.clear();
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
        title: Text('Daftar ' + peran),
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
                helpText: 'Cari ' + peran,
                textController: editingController,
                onSuffixTap: () {
                  setState(() {
                    editingController.clear();
                  });
                },
                onSubmitted: (String) {},
              ),
            ),
            if (peran != "User")
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
                                builder: (context) => addPeran(id, peran)),
                          );
                        },
                        splashColor: Colors.blue,
                        splashRadius: 30,
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ),
                  Text("Add " + peran)
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
                                //Color(Colors.blue);

                                Text(
                                  "Nama: " + i['nama'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                                if (peran == "Imam")
                                  Text(
                                    "Gereja: " + i['imamGereja'][0]['nama'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                if (peran == "User")
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
                                        child: Text("Banned " + peran),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () async {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: Text('Confirm Banned'),
                                              content: Text('Yakin ingin ban ' +
                                                  peran +
                                                  ' ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await updatePeran(
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
                                        child: Text("Unbanned " + peran),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () async {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: Text('Confirm Unbanned'),
                                              content: Text(
                                                  'Yakin ingin Unbanned ' +
                                                      peran +
                                                      ' ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await updatePeran(
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
                    print(e);

                    return Center(child: CircularProgressIndicator());
                  }
                }),

            /////////
          ],
        ),
      ),
    );
  }
}
