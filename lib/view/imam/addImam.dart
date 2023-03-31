import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
import 'package:admin_pelayanan_katolik/view/gereja/daftarGereja.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../Agen/MessagePassing.dart';

class addImam extends StatefulWidget {
  @override
  final id;
  addImam(this.id);

  @override
  _addImam createState() => _addImam(this.id);
}

class _addImam extends State<addImam> {
  final id;

  TextEditingController nama = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  _addImam(this.id);
  var idGerejaSelected;
  var gereja = [];
  var idGereja = [];

  Future submit() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPendaftaran");
    // await msg.setContent([
    //   ["add imam"],
    //   [email.text],
    //   [password.text],
    //   [idGerejaSelected],
    //   [nama.text],
    //   [id]
    // ]);
    // var hasil;
    // await msg.send();

    // hasil = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'View',
        'Agent Pendaftaran',
        "REQUEST",
        Task('add imam',
            [email.text, password.text, idGerejaSelected, nama.text, id]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await messagePassing.messageGetToView();
    if (hasil == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal menambahkan Imam",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil menambahkan Imam",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => DaftarGereja(id)),
      );
    }
  }

  Future callDb() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPencarian");
    // await msg.setContent([
    //   ["cari gereja"]
    // ]);

    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();

    // return hasil;
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'View', 'Agent Pencarian', "REQUEST", Task('cari gereja', null));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var result = await messagePassing.messageGetToView();

    await completer.future;

    return result;
  }

  // void initState() {
  //   super.initState();
  //   callDb().then((result) {
  //     setState(() {
  //       for (var i = 0; i < hasil.length; i++) {
  //         gereja.add(hasil[i]['nama']);
  //         idGereja.add(hasil[i]['_id']);
  //       }
  //     });
  //   });
  // }

  Future pullRefresh() async {
    setState(() {
      callDb().then((result) {
        gereja.clear();
        idGereja.clear();
      });
      ;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Tambah Imam"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(children: [
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    for (var i = 0; i < snapshot.data.length; i++) {
                      gereja.add(snapshot.data[i]['nama']);
                      idGereja.add(snapshot.data[i]['_id']);
                    }
                    print(gereja);
                    return Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Text(
                            "Nama",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: nama,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Nama Imam",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Text(
                            "Email",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: email,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email Akun",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Text(
                            "Password",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password Akun",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Text(
                            "Gereja",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          DropdownSearch<dynamic>(
                            // popupProps: PopupProps.menu(
                            //   showSelectedItems: true,
                            //   disabledItemFn: (String s) => s.startsWith('I'),
                            // ),
                            items: gereja,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Pilih Gereja",
                                hintText: "Pilih Gereja",
                              ),
                            ),
                            onChanged: (dynamic? data) {
                              var position = gereja.indexOf(data);
                              idGerejaSelected = idGereja[position];
                              print(idGerejaSelected);
                            },
                          ),
                        ],
                      ),
                    ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  child: Text("Submit"),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () async {
                    submit();
                  }),
            ),
          ]),
        ));
  }
}
