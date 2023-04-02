import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
import 'package:admin_pelayanan_katolik/view/gereja/daftarGereja.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';

import '../../Agen/Task.dart';

class addGereja extends StatefulWidget {
  @override
  final id;
  addGereja(this.id);

  @override
  _addGereja createState() => _addGereja(this.id);
}

class _addGereja extends State<addGereja> {
  final id;
  double? lattitude = 0;
  double? longttitude = 0;
  TextEditingController nama = new TextEditingController();
  TextEditingController alamat = new TextEditingController();
  TextEditingController paroki = new TextEditingController();
  TextEditingController lingkungan = new TextEditingController();
  TextEditingController deskripsi = new TextEditingController();
  _addGereja(this.id);

  Future submit() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPendaftaran");
    // await msg.setContent([
    //   ["add gereja"],
    //   [nama.text],
    //   [alamat.text],
    //   [paroki.text],
    //   [lingkungan.text],
    //   [deskripsi.text],
    //   [lattitude],
    //   [longttitude],
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
        Task('add gereja', [
          nama.text,
          alamat.text,
          paroki.text,
          lingkungan.text,
          deskripsi.text,
          lattitude,
          longttitude,
          id
        ]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await messagePassing.messageGetToView();

    if (hasil == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal menambahkan Gereja",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil menambahkan Gereja",
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Tambah Gereja"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView(children: [
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
                  hintText: "Nama Gereja",
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
              "Address",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            TextField(
              controller: alamat,
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
                  hintText: "Alamat Gereja",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            RaisedButton(
                textColor: Colors.white,
                color: Colors.lightBlue,
                child: Text("Generate Coordinate"),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () async {
                  try {
                    print(alamat.text);
                    GeoCode geoCode = GeoCode();
                    Coordinates coordinates =
                        await geoCode.forwardGeocoding(address: alamat.text);
                    print("Latitude: ${coordinates.latitude}");
                    print("Longitude: ${coordinates.longitude}");
                    setState(() {
                      lattitude = coordinates.latitude;
                      longttitude = coordinates.longitude;
                    });
                  } catch (e) {
                    print(e);
                  }
                }),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Lattitude",
                    ),
                    Text(
                      lattitude.toString(),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Column(
                  children: [
                    Text(
                      "Longtittude",
                    ),
                    Text(
                      longttitude.toString(),
                    ),
                  ],
                )
              ],
            )
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
              "Paroki",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            TextField(
              controller: paroki,
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
                  hintText: "Paroki Gereja",
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
              "Lingkungan",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            TextField(
              controller: lingkungan,
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
                  hintText: "Lingkungan Gereja",
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
              "Deskripsi",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            TextField(
              controller: deskripsi,
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
                  hintText: "Deskripsi Gereja",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ],
        ),
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
    );
  }
}
