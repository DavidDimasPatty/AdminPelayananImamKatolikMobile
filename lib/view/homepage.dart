import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';

import 'package:admin_pelayanan_katolik/FadeAnimation.dart';
import 'package:admin_pelayanan_katolik/view/gereja/daftarGereja.dart';
import 'package:admin_pelayanan_katolik/view/imam/daftarImam.dart';
import 'package:admin_pelayanan_katolik/view/user/daftarUser.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  final id;
  HomePage(this.id);
  @override
  _HomePage createState() => _HomePage(this.id);
}

class _HomePage extends State<HomePage> {
  var id;
  _HomePage(this.id);

  Future callJumlah() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPencarian");
    // await msg.setContent([
    //   ["cari jumlah"]
    // ]);
    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // return await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari jumlah', null));

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
    setState(() {
      callJumlah();
    });
  }

  Future pullRefresh() async {
    setState(() {
      callJumlah();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome Admin"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            /////////
            FutureBuilder(
                future: callJumlah(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    return Column(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 20.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Total User Mendaftar",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot.data[0].toString(),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "User Unbanned",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[1]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "User Banned",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[2]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 20.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Total Gereja Mendaftar",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot.data[3].toString(),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "Gereja Unbanned",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[4]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "Gereja Banned",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[5]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 20.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Total Imam Mendaftar",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot.data[6].toString(),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "Imam Unbanned",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[7]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "Imam Banned",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[8]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } catch (e) {
                    print(e);

                    return Center(child: CircularProgressIndicator());
                  }
                }),
            SizedBox(
              height: 20,
            ),
            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaftarUser(id)),
                );
              },
              child: Container(
                  margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(children: <Widget>[
                    //Color(Colors.blue);

                    Text(
                      "Daftar User",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),

            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaftarGereja(id)),
                );
              },
              child: Container(
                  margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(children: <Widget>[
                    //Color(Colors.blue);

                    Text(
                      "Daftar Gereja",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),
            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaftarImam(id)),
                );
              },
              child: Container(
                  margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(children: <Widget>[
                    //Color(Colors.blue);

                    Text(
                      "Daftar Imam",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),
            SizedBox(
              height: 20,
            ),
            /////////
            ///
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
