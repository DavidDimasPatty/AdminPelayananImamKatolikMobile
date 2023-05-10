// import 'dart:async';

// import 'package:admin_pelayanan_katolik/Agen/Message.dart';
// import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
// import 'package:admin_pelayanan_katolik/Agen/Task.dart';
// import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';

// import 'package:admin_pelayanan_katolik/view/imam/addImam.dart';
// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class DaftarImam extends StatefulWidget {
//   final id;
//   DaftarImam(this.id);
//   @override
//   _DaftarImam createState() => _DaftarImam(this.id);
// }

// class _DaftarImam extends State<DaftarImam> {
//   List hasil = [];
//   StreamController _controller = StreamController();
//   ScrollController _scrollController = ScrollController();
//   int data = 5;

//   List dummyTemp = [];

//   final id;
//   _DaftarImam(this.id);

//   Future callDb() async {
//     Completer<void> completer = Completer<void>();
//     Message message = Message(
//         'Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari imam', null));

//     MessagePassing messagePassing = MessagePassing();
//     var data = await messagePassing.sendMessage(message);
//     var hasilPencarian = await AgentPage.getData();

//     completer.complete();

//     await completer.future;
//     return await hasilPencarian;
//   }

//   @override
//   void initState() {
//     super.initState();
//     callDb().then((result) {
//       setState(() {
//         hasil.addAll(result);
//         dummyTemp.addAll(result);
//         _controller.add(result);
//       });
//     });
//   }

//   filterSearchResults(String query) {
//     if (query.isNotEmpty) {
//       List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
//       for (var item in dummyTemp) {
//         if (item['nama']
//             .toString()
//             .toLowerCase()
//             .contains(query.toLowerCase())) {
//           listOMaps.add(item);
//         }
//       }
//       setState(() {
//         hasil.clear();
//         hasil.addAll(listOMaps);
//       });
//     } else {
//       setState(() {
//         hasil.clear();
//         hasil.addAll(dummyTemp);
//       });
//     }
//   }

//   Future updateImam(idImam, status) async {
//     Completer<void> completer = Completer<void>();
//     Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
//         Tasks('update imam', [idImam, status]));

//     MessagePassing messagePassing = MessagePassing();
//     var data = await messagePassing.sendMessage(message);
//     var hasilDaftar = await AgentPage.getData();

//     completer.complete();

//     await completer.future;

//     if (hasilDaftar == "failed") {
//       Fluttertoast.showToast(
//           msg: "Gagal Banned Imam",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 2,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     } else if (hasilDaftar == "oke") {
//       Fluttertoast.showToast(
//           msg: "Berhasil Banned Imam",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 2,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       callDb().then((result) {
//         setState(() {
//           hasil.clear();
//           dummyTemp.clear();
//           hasil.clear();
//           hasil.addAll(result);
//           dummyTemp.addAll(result);
//           _controller.add(result);
//         });
//       });
//     }
//   }

//   Future pullRefresh() async {
//     callDb().then((result) {
//       setState(() {
//         hasil.clear();
//         dummyTemp.clear();
//         hasil.clear();
//         hasil.addAll(result);
//         dummyTemp.addAll(result);
//         _controller.add(result);
//       });
//     });
//   }

//   TextEditingController editingController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     editingController.addListener(() async {
//       await filterSearchResults(editingController.text);
//     });
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         setState(() {
//           data = data + 5;
//         });
//       }
//     });
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         title: Text('Daftar Imam'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: pullRefresh,
//         child: ListView(
//           controller: _scrollController,
//           shrinkWrap: true,
//           padding: EdgeInsets.only(right: 15, left: 15),
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(right: 10, left: 10),
//               child: AnimSearchBar(
//                 autoFocus: false,
//                 width: 400,
//                 rtl: true,
//                 helpText: 'Cari Imam',
//                 textController: editingController,
//                 onSuffixTap: () {
//                   setState(() {
//                     editingController.clear();
//                   });
//                 },
//                 onSubmitted: (String) {},
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(right: 10, left: 10),
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: IconButton(
//                       color: Colors.black,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => addImam(id)),
//                         );
//                       },
//                       splashColor: Colors.blue,
//                       splashRadius: 30,
//                       icon: Icon(Icons.add),
//                     ),
//                   ),
//                 ),
//                 Text("Add Imam")
//               ],
//             ),
//             Padding(padding: EdgeInsets.symmetric(vertical: 10)),
//             Padding(padding: EdgeInsets.symmetric(vertical: 10)),
//             /////////
//             StreamBuilder(
//                 stream: _controller.stream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   }

//                   if (!snapshot.hasData) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   try {
//                     return Column(children: [
//                       for (var i in hasil.take(data))
//                         InkWell(
//                           borderRadius: new BorderRadius.circular(24),
//                           onTap: () {},
//                           child: Container(
//                               margin: EdgeInsets.only(
//                                   right: 15, left: 15, bottom: 20),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                     begin: Alignment.topRight,
//                                     end: Alignment.topLeft,
//                                     colors: [
//                                       Colors.blueGrey,
//                                       Colors.lightBlue,
//                                     ]),
//                                 border: Border.all(
//                                   color: Colors.lightBlue,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               child: Column(children: <Widget>[
//                                 //Color(Colors.blue);

//                                 Text(
//                                   "Nama: " + i['nama'],
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.w300),
//                                   textAlign: TextAlign.center,
//                                 ),

//                                 Text(
//                                   "Gereja: " + i['imamGereja'][0]['nama'],
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w300),
//                                   textAlign: TextAlign.center,
//                                 ),

//                                 if (i['banned'] == 0)
//                                   Text(
//                                     'Banned: No',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 12),
//                                   ),
//                                 if (i['banned'] == 1)
//                                   Text(
//                                     'Banned: Yes',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 12),
//                                   ),
//                                 if (i['banned'] == 0)
//                                   SizedBox(
//                                     width: double.infinity,
//                                     child: RaisedButton(
//                                         textColor: Colors.white,
//                                         color: Colors.lightBlue,
//                                         child: Text("Banned Imam"),
//                                         shape: new RoundedRectangleBorder(
//                                           borderRadius:
//                                               new BorderRadius.circular(30.0),
//                                         ),
//                                         onPressed: () async {
//                                           showDialog<String>(
//                                             context: context,
//                                             builder: (BuildContext context) =>
//                                                 AlertDialog(
//                                               title:
//                                                   const Text('Confirm Banned'),
//                                               content: const Text(
//                                                   'Yakin ingin ban Imam ini?'),
//                                               actions: <Widget>[
//                                                 TextButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(
//                                                           context, 'Cancel'),
//                                                   child: const Text('Tidak'),
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () async {
//                                                     await updateImam(
//                                                         i["_id"], 1);
//                                                     Navigator.pop(context);
//                                                     setState(() {
//                                                       callDb()
//                                                           .then((result) {});
//                                                     });
//                                                   },
//                                                   child: const Text('Ya'),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                   ),
//                                 if (i['banned'] == 1)
//                                   SizedBox(
//                                     width: double.infinity,
//                                     child: RaisedButton(
//                                         textColor: Colors.white,
//                                         color: Colors.lightBlue,
//                                         child: Text("Unbanned Imam"),
//                                         shape: new RoundedRectangleBorder(
//                                           borderRadius:
//                                               new BorderRadius.circular(30.0),
//                                         ),
//                                         onPressed: () async {
//                                           showDialog<String>(
//                                             context: context,
//                                             builder: (BuildContext context) =>
//                                                 AlertDialog(
//                                               title: const Text(
//                                                   'Confirm Unbanned'),
//                                               content: const Text(
//                                                   'Yakin ingin Unbanned Imam ini?'),
//                                               actions: <Widget>[
//                                                 TextButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(
//                                                           context, 'Cancel'),
//                                                   child: const Text('Tidak'),
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () async {
//                                                     await updateImam(
//                                                         i["_id"], 0);
//                                                     Navigator.pop(context);
//                                                     setState(() {
//                                                       callDb()
//                                                           .then((result) {});
//                                                     });
//                                                   },
//                                                   child: const Text('Ya'),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                   ),
//                               ])),
//                         )
//                     ]);
//                   } catch (e) {
//                     print(e);

//                     return Center(child: CircularProgressIndicator());
//                   }
//                 }),

//             /////////
//           ],
//         ),
//       ),
//     );
//   }
// }
