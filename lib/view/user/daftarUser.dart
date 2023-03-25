import 'dart:io';

import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
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
  var names;
  var emails;
  var distance;
  List daftarUser = [];

  List dummyTemp = [];

  final id;
  _DaftarUser(this.id);

  Future callDb() async {
    Messages msg = new Messages();
    await msg.addReceiver("agenPencarian");
    await msg.setContent([
      ["cari user"]
    ]);
    List hasil = [];
    await msg.send();
    await Future.delayed(Duration(seconds: 1));
    hasil = await AgenPage().receiverTampilan();
    return hasil;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        daftarUser.addAll(result);
        dummyTemp.addAll(result);
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
        daftarUser.clear();
        daftarUser.addAll(listOMaps);
      });
      return daftarUser;
    } else {
      setState(() {
        daftarUser.clear();
        daftarUser.addAll(dummyTemp);
      });
    }
  }

  Future updateUser(idUser, status) async {
    Messages msg = new Messages();
    await msg.addReceiver("agenPencarian");
    await msg.setContent([
      ["update user"],
      [idUser],
      [status]
    ]);
    var hasil;
    await msg.send();
    hasil = await AgenPage().receiverTampilan();

    if (hasil == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Banned User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
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
          daftarUser.clear();
          dummyTemp.clear();
          daftarUser.addAll(result);
          dummyTemp.addAll(result);
          filterSearchResults(editingController.text);
        });
      });
    }
  }

  Future pullRefresh() async {
    setState(() {
      callDb().then((result) {
        setState(() {
          daftarUser.clear();
          dummyTemp.clear();
          daftarUser.addAll(result);
          dummyTemp.addAll(result);
          filterSearchResults(editingController.text);
        });
      });
      ;
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
              FutureBuilder(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      return Column(children: [
                        for (var i in daftarUser)
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
                                                        callDb().then((result) {
                                                          setState(() {
                                                            daftarUser.clear();
                                                            dummyTemp.clear();
                                                            daftarUser
                                                                .addAll(result);
                                                            dummyTemp
                                                                .addAll(result);
                                                            filterSearchResults(
                                                                editingController
                                                                    .text);
                                                          });
                                                        });
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
                                                        callDb().then((result) {
                                                          setState(() {
                                                            daftarUser.clear();
                                                            dummyTemp.clear();
                                                            daftarUser
                                                                .addAll(result);
                                                            dummyTemp
                                                                .addAll(result);
                                                            filterSearchResults(
                                                                editingController
                                                                    .text);
                                                          });
                                                        });
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
