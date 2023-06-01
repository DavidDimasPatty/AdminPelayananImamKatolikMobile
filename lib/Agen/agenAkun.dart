import 'dart:async';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class agenAkun extends Agent {
  agenAkun() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {"login": _estimatedTime};

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "login":
        return _login(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _login(dynamic data, String sender) async {
    var adminCollection = await MongoDatabase.db.collection(ADMIN_COLLECTION);

    var conn = await adminCollection.find({'user': data[0], 'password': data[1]}).toList();
    //Pencarian berdasarkan
    //password dan email
    Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi/ pencarian data akun', conn));
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Akun";
    //nama agen
    plan = [
      Plan("login", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("login", List<Map<String, Object?>>, _timeAction["login"]),
    ];
  }
}
