import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/messages.dart';
import 'package:admin_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:admin_pelayanan_katolik/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future callDb() async {
  Messages msg = new Messages();
  await msg.addReceiver("agenSetting");
  await msg.setContent([
    ["setting User"]
  ]);
  await msg.send();
  return await AgenPage().receiverTampilan();
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
