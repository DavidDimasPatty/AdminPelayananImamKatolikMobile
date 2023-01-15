import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DatabaseFolder/mongodb.dart';
import 'homePage.dart';

class DaftarGereja extends StatefulWidget {
  final id;
  DaftarGereja(this.id);
  @override
  _DaftarGereja createState() => _DaftarGereja(this.id);
}

class _DaftarGereja extends State<DaftarGereja> {
  var names;
  var emails;
  var distance;
  List daftarUser = [];

  List dummyTemp = [];

  final id;
  _DaftarGereja(this.id);

  Future<List> callDb() async {
    return await MongoDatabase.gerejaTerdaftar();
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

  void updateKegiatan(idKegiatan, status) async {
    var hasil = await MongoDatabase.updateStatusGereja(idKegiatan, status);

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
        });
      });
    }
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
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.account_circle_rounded),
        //     onPressed: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //       builder: (context) => Profile(names, idUser, idGereja)),
        //       // );
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.settings),
        //     onPressed: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //       builder: (context) => Settings(names, emails, idUser)),
        //       // );
        //     },
        //   ),
        // ],
      ),
      body: ListView(children: [
        ListView(
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
                        "Nama: " + i['nama'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Paroki: ' + i['paroki'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        'Address: ' + i['address'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      if (i['banned'] == 0)
                        Text(
                          'Banned: No',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      if (i['banned'] == 1)
                        Text(
                          'Banned: Yes',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      if (i['banned'] == 0)
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.lightBlue,
                              child: Text("Banned Gereja"),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Confirm Banned'),
                                    content: const Text(
                                        'Yakin ingin ban Gereja ini?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Tidak'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          updateKegiatan(i["_id"], 1);
                                          Navigator.pop(context);
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
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Confirm Unbanned'),
                                    content: const Text(
                                        'Yakin ingin Unbanned Gereja ini?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Tidak'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          updateKegiatan(i["_id"], 0);
                                          Navigator.pop(context);
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

            /////////
          ],
        ),
      ]),
      // bottomNavigationBar: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //           topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      //       boxShadow: [
      //         BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
      //       ],
      //     ),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(30.0),
      //         topRight: Radius.circular(30.0),
      //       ),
      //       child: BottomNavigationBar(
      //         type: BottomNavigationBarType.fixed,
      //         showUnselectedLabels: true,
      //         unselectedItemColor: Colors.blue,
      //         items: <BottomNavigationBarItem>[
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
      //             label: "Home",
      //           ),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
      //             label: "Histori",
      //           )
      //         ],
      //         onTap: (index) {
      //           if (index == 1) {
      //             // Navigator.push(
      //             //   context,
      //             //   MaterialPageRoute(
      //             //       builder: (context) => History(names, idUser, idGereja)),
      //             // );
      //           } else if (index == 0) {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => HomePage(id)),
      //             );
      //           }
      //         },
      //       ),
      //     )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     openCamera();
      //   },
      //   tooltip: 'Increment',
      //   child: new Icon(Icons.camera_alt_rounded),
      // ),
    );
  }
}
