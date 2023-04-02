import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:admin_pelayanan_katolik/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future callDb() async {
  Completer<void> completer = Completer<void>();
  Message message =
      Message('View', 'Agent Setting', "REQUEST", Task('setting user', null));

  MessagePassing messagePassing = MessagePassing();
  var data = await messagePassing.sendMessage(message);
  completer.complete();
  var hasil = await messagePassing.messageGetToView();
  return hasil;
}

void main() async {
  await callDb();

  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp();
  // await MongoDatabase.connect();

  // runApp(MaterialApp(
  //   title: 'Navigation Basics',
  //   home: Login(),
  // ));
}
