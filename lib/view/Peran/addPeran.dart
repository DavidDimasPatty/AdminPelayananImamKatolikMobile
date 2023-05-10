import 'dart:async';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/view/Peran/daftarPeran.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Agen/Task.dart';

class addPeran extends StatefulWidget {
  @override
  final id;
  String peran;
  addPeran(this.id, this.peran);

  @override
  _addPeran createState() => _addPeran(this.id, this.peran);
}

class _addPeran extends State<addPeran> {
  final id;
  String peran;
  _addPeran(this.id, this.peran);

  ///Field Gereja
  TextEditingController lattitude = new TextEditingController();
  TextEditingController longttitude = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  TextEditingController alamat = new TextEditingController();
  TextEditingController paroki = new TextEditingController();
  TextEditingController lingkungan = new TextEditingController();
  TextEditingController deskripsi = new TextEditingController();
  //Field Imam
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  var idGerejaSelected;
  var idRoleSelected;
  var gereja = [];
  var idGereja = [];
  var role = ["Imam", "Sekretariat"];
  var idRole = [0, 1];
//////////////////

  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari Gereja', null));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilPencarian = await AgentPage.getData();

    completer.complete();

    await completer.future;
    return await hasilPencarian;
  }

  Future pullRefresh() async {
    setState(() {
      callDb().then((result) {
        gereja.clear();
        idGereja.clear();
      });
      ;
    });
  }

  Future submit() async {
    Completer<void> completer = Completer<void>();
    Message message;
    var hasilDaftar;

    if (peran == "Gereja") {
      if (nama.text != "" &&
          alamat.text != "" &&
          paroki.text != "" &&
          lingkungan.text != "" &&
          lattitude != "" &&
          longttitude != "") {
        message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('add ' + peran, [
              nama.text,
              alamat.text,
              paroki.text,
              lingkungan.text,
              deskripsi.text,
              double.parse(lattitude.text),
              double.parse(longttitude.text),
              id
            ]));
        MessagePassing messagePassing = MessagePassing();
        var data = await messagePassing.sendMessage(message);
        hasilDaftar = await AgentPage.getData();

        completer.complete();

        await completer.future;
        print(hasilDaftar);
        if (hasilDaftar == "nama") {
          Fluttertoast.showToast(
              msg: "Nama sudah digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (hasilDaftar == "failed") {
          Fluttertoast.showToast(
              msg: "Gagal menambahkan " + peran,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Berhasil menambahkan " + peran,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => DaftarPeran(id, "Gereja")),
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Lengkapi semua input",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      if (email.text != "" &&
          password.text != "" &&
          idGerejaSelected != null &&
          nama.text != null &&
          idRoleSelected != null) {
        message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('add ' + peran, [
              email.text,
              password.text,
              idGerejaSelected,
              nama.text,
              idRoleSelected,
              id
            ]));
        MessagePassing messagePassing = MessagePassing();
        var data = await messagePassing.sendMessage(message);
        hasilDaftar = await AgentPage.getData();

        completer.complete();

        await completer.future;
        if (hasilDaftar == "nama") {
          Fluttertoast.showToast(
              msg: "Nama sudah digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (hasilDaftar == "email") {
          Fluttertoast.showToast(
              msg: "Email sudah digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (hasilDaftar == "failed") {
          Fluttertoast.showToast(
              msg: "Gagal menambahkan " + peran,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Berhasil menambahkan " + peran,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => DaftarPeran(id, "Gereja")),
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Lengkapi semua input",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Tambah " + peran),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(children: [
            if (peran == "Imam")
              FutureBuilder(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      for (var i = 0; i < snapshot.data.length; i++) {
                        gereja.add(snapshot.data[i]['nama']);
                        idGereja.add(snapshot.data[i]['_id']);
                      }

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
                              "Role",
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
                              items: role,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Pilih Role",
                                  hintText: "Pilih Role",
                                ),
                              ),
                              onChanged: (dynamic? data) {
                                var position = role.indexOf(data);
                                idRoleSelected = idRole[position];
                              },
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
                              },
                            ),
                          ],
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
                      ]);
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            if (peran == "Gereja")
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
                      // RaisedButton(
                      //     textColor: Colors.white,
                      //     color: Colors.lightBlue,
                      //     child: Text("Generate Coordinate"),
                      //     shape: new RoundedRectangleBorder(
                      //       borderRadius: new BorderRadius.circular(30.0),
                      //     ),
                      //     onPressed: () async {
                      //       try {
                      //         print(alamat.text);
                      //         GeoCode geoCode = GeoCode();
                      //         Coordinates coordinates = await geoCode
                      //             .forwardGeocoding(address: alamat.text);
                      //         print("Latitude: ${coordinates.latitude}");
                      //         print("Longitude: ${coordinates.longitude}");
                      //         setState(() {
                      //           lattitude = coordinates.latitude;
                      //           longttitude = coordinates.longitude;
                      //         });
                      //       } catch (e) {
                      //         print(e);
                      //       }
                      //     }),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Text(
                        "Lattitude dan Longttitude",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.-]")),
                              ],
                              controller: lattitude,
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
                                  hintText: "Lattitude",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.-]")),
                              ],
                              controller: longttitude,
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
                                  hintText: "Longttitude",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
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
                ],
              ),
          ]),
        ));
  }
}
