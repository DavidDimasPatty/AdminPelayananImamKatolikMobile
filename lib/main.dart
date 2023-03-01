import 'package:admin_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:admin_pelayanan_katolik/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await MongoDatabase.connect();

  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: Login(),
  ));
}
