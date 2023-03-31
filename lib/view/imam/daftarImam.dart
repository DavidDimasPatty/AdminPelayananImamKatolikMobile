import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
import 'package:admin_pelayanan_katolik/view/imam/addImam.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DaftarImam extends StatefulWidget {
  final id;
  DaftarImam(this.id);
  @override
  _DaftarImam createState() => _DaftarImam(this.id);
}

class _DaftarImam extends State<DaftarImam> {
  List daftarUser = [];

  List dummyTemp = [];

  final id;
  _DaftarImam(this.id);

  Future callDb() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPencarian");
    // await msg.setContent([
    //   ["cari imam"]
    // ]);
    // List hasil = [];
    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();

    // return hasil;
    Completer<void> completer = Completer<void>();
    Message message =
        Message('View', 'Agent Pencarian', "REQUEST", Task('cari imam', null));

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

  Future updateImam(idImam, status) async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPendaftaran");
    // await msg.setContent([
    //   ["update imam"],
    //   [idKegiatan],
    //   [status]
    // ]);
    // var hasil;
    // await msg.send();
    // hasil = await AgenPage().receiverTampilan();

    Completer<void> completer = Completer<void>();
    Message message = Message('View', 'Agent Pendaftaran', "REQUEST",
        Task('update imam', [idImam, status]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await messagePassing.messageGetToView();

    await completer.future;

    if (hasil == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal Banned Imam",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (hasil == "oke") {
      Fluttertoast.showToast(
          msg: "Berhasil Banned Imam",
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
        title: Text('Daftar Imam'),
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
                helpText: 'Cari Imam',
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
                          MaterialPageRoute(builder: (context) => addImam(id)),
                        );
                      },
                      splashColor: Colors.blue,
                      splashRadius: 30,
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
                Text("Add Imam")
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
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
                                  "Nama: " + i['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),

                                Text(
                                  "Gereja: " + i['imamGereja'][0]['nama'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                                // Text(
                                //   'Paroki: ' + i['paroki'].toString(),
                                //   style: TextStyle(
                                //       color: Colors.white, fontSize: 12),
                                // ),
                                // Text(
                                //   'Address: ' + i['address'].toString(),
                                //   style: TextStyle(
                                //       color: Colors.white, fontSize: 12),
                                // ),
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
                                        child: Text("Banned Imam"),
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
                                                  'Yakin ingin ban Imam ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await updateImam(
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
                                        child: Text("Unbanned Imam"),
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
                                                  'Yakin ingin Unbanned Imam ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await updateImam(
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
