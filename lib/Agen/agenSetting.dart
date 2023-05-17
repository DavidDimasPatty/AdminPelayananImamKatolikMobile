import 'dart:async';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentSetting extends Agent {
  AgentSetting() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }
  static int _estimatedTime = 20;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {"setting user": _estimatedTime};

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Message> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "setting user":
        return _settingUser(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> _settingUser(dynamic data, String sender) async {
    await dotenv.load(fileName: ".env");
    var statusF = await Firebase.initializeApp();
    var statusM = await MongoDatabase.connect();
    WidgetsFlutterBinding.ensureInitialized();

    Message message = Message(agentName, sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  @override
  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Setting";
    //nama agen
    plan = [
      Plan("setting user", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("setting user", String, _timeAction["setting user"]),
    ];
  }
}
