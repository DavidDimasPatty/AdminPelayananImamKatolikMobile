import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
import 'package:admin_pelayanan_katolik/FadeAnimation.dart';
import 'package:admin_pelayanan_katolik/daftarGereja.dart';
import 'package:admin_pelayanan_katolik/daftarUser.dart';
import 'package:flutter/material.dart';
//import 'package:pelayanan_iman_katolik/forgetPassword.dart';
//import 'package:pelayanan_iman_katolik/singup.dart';
import 'DatabaseFolder/mongodb.dart';
//import 'package:pelayanan_iman_katolik/homePage.dart';
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
  List hasil = [];

  Future callJumlah() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari jumlah"]
    ]);
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    hasil = AgenPage().receiverTampilan();

    return hasil;
  }

  Future pullRefresh() async {
    setState(() {
      callJumlah();
    });
  }

  void initState() {
    super.initState();

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
          child: ListView(children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(right: 15, left: 15),
              children: <Widget>[
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            hasil[0].toString(),
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
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            hasil[1].toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                            hasil[2].toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            hasil[3].toString(),
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
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            hasil[4].toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                            hasil[5].toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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

                /////////
                ///
              ],
            ),
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
