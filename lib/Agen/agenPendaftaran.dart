import 'dart:async';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/DatabaseFolder/modelDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPendaftaran extends Agent {
  AgentPendaftaran() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "update User": _estimatedTime,
    "update Imam": _estimatedTime,
    "update Gereja": _estimatedTime,
    "add Imam": _estimatedTime,
    "add Gereja": _estimatedTime,
    "add aturan pelayanan": _estimatedTime,
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "update User":
        return _updateUser(data.task.data, sender);
      case "update Imam":
        return _updateImam(data.task.data, sender);
      case "update Gereja":
        return _updateGereja(data.task.data, sender);
      case "add Imam":
        return _addImam(data.task.data, sender);
      case "add Gereja":
        return _addGereja(data.task.data, sender);
      case "add aturan pelayanan":
        return _addAturanPelayanan(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _updateUser(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);

    var update = await userCollection.updateOne(where.eq('_id', data[0]), modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _updateImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var update = await imamCollection.updateOne(where.eq('_id', data[0]), modify.set('banned', data[1]).set("updatedAt", DateTime.now()));
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _updateGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var update = await gerejaCollection.updateOne(where.eq('_id', data[0]), modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _addImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var checkName = await imamCollection.find(where.eq('nama', data[3])).toList();

    var checkEmail = await imamCollection.find(where.eq('email', data[0])).toList();

    if (checkName.length > 0) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "nama"));
      return message;
    } else if (checkEmail.length > 0) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "email"));
      return message;
    }
    var configJson = modelDB.imam(data[0], data[1], data[2], data[3], "", "", 0, data[4], 1, 1, 1, 1, DateTime.now(), DateTime.now(), data[5], data[5]);

    var addImam = await imamCollection.insertOne(configJson);

    if (addImam.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _addGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var checkName = await gerejaCollection.find(where.eq('nama', data[0])).toList();

    if (checkName.length > 0) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "nama"));
      return message;
    }
    var configJson = modelDB.Gereja(data[0], data[1], data[2], data[3], data[4], data[5], data[6], 0, "", DateTime.now(), data[7], DateTime.now(), data[7]);

    var addGereja = await gerejaCollection.insertOne(configJson);

    if (addGereja.isSuccess) {
      Completer<void> completer = Completer<void>();
      Messages message2 = Messages(agentName, 'Agent Pencarian', "REQUEST", Tasks('cari gereja terakhir', data[7]));
      MessagePassing messagePassing = MessagePassing();
      await messagePassing.sendMessage(message2);
      Messages message = Messages(agentName, sender, "INFORM", Tasks('done', null));
      completer.complete();

      await completer.future;
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _addAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection = MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);

    var configJson = modelDB.aturanPelayanan(data[1][0]["_id"], "", "", "", "", "", "", "", DateTime.now(), data[0], DateTime.now(), data[0]);

    var addAturan = await aturanPelayananCollection.insertOne(configJson);

    if (addAturan.isSuccess) {
      Messages message = Messages(agentName, 'Agent Page', "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, 'Agent Page', "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Pendaftaran";
    //nama agen
    plan = [
      Plan("update User", "REQUEST"),
      Plan("update Imam", "REQUEST"),
      Plan("update Gereja", "REQUEST"),
      Plan("add Imam", "REQUEST"),
      Plan("add Gereja", "REQUEST"),
      Plan("add aturan pelayanan", "INFORM"),
    ];
    //Perencanaan agen
    goals = [
      Goals("update User", String, _timeAction["update User"]),
      Goals("update Imam", String, _timeAction["update Imam"]),
      Goals("update Gereja", String, _timeAction["update Gereja"]),
      Goals("add Imam", String, _timeAction["add Imam"]),
      Goals("add Gereja", String, _timeAction["add Gereja"]),
      Goals("add aturan pelayanan", String, _timeAction["add aturan pelayanan"]),
    ];
  }
}
