import 'dart:developer';
import 'dart:io';

import 'package:admin_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:admin_pelayanan_katolik/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';

import 'messages.dart';

class AgenSetting {
  AgenSetting() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data[0][0] == "setting User") {
          try {
            await dotenv.load(fileName: ".env");
            await Firebase.initializeApp();
            await MongoDatabase.connect().then((result) async {
              WidgetsFlutterBinding.ensureInitialized();
              msg.addReceiver("agenPage");
              msg.setContent("Application Setting Ready");
              await msg.send();
              runApp(await MaterialApp(
                title: 'Navigation Basics',
                home: Login(),
              ));
            });
          } catch (e) {
            msg.addReceiver("agenPage");
            msg.setContent("Application Setting Failed");
            await msg.send();
          }
        }
        if (data[0][0] == "log out") {
          final directory = await getApplicationDocumentsDirectory();
          var path = directory.path;

          final file = await File('$path/loginImam.txt');
          await file.writeAsString("");
          msg.addReceiver("agenPage");
          msg.setContent("oke");
          await msg.send();
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "ready") {
          print("Agen Setting Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
