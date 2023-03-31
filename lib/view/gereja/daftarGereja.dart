import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
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
  List daftarUser = [];
  bool isLoading = true;
  List dummyTemp = [];

  final id;
  _DaftarGereja(this.id);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPencarian");
    // await msg.setContent([
    //   ["cari gereja"]
    // ]);
    // List hasil;
    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // return await AgenPage().receiverTampilan();

    Completer<void> completer = Completer<void>();
    Message message =
        Message('View', 'Agent A', "REQUEST", Task('cari gereja', null));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var result = await messagePassing.messageGetToView();

    await completer.future;

    return result;
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
        if (item['nama']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          print("SOORRRY");
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

  Future updateGereja(idKegiatan, status) async {
    Messages msg = new Messages();
    await msg.addReceiver("agenPencarian");
    await msg.setContent([
      ["update gereja"],
      [idKegiatan],
      [status]
    ]);
    var hasil;
    await msg.send();

    hasil = await AgenPage().receiverTampilan();

    if (hasil == "fail") {
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
        title: Text('Daftar Gereja'),
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

            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    return Column(children: [
                      // for (var i in daftarUser)
                      for (var i in daftarUser)
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
