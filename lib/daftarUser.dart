import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DatabaseFolder/mongodb.dart';
import 'homePage.dart';

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

  Future<List> callDb() async {
    return await MongoDatabase.userTerdaftar();
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

  void updateKegiatan(idKegiatan, status) async {
    var hasil = await MongoDatabase.updateStatusUser(idKegiatan, status);

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
        title: Text('Daftar User'),
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
                        "Nama :" + i['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Tanggal Daftar: ' +
                            i['tanggalDaftar'].toString().substring(0, 10),
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
                              child: Text("Banned User"),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Confirm Banned'),
                                    content:
                                        const Text('Yakin ingin ban user ini?'),
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
                              child: Text("Unbanned User"),
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
                                        'Yakin ingin Unbanned user ini?'),
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
