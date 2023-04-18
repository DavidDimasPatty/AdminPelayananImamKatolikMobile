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
    _initAgent();
  }

  static int _estimatedTime = 5;
  static Map<String, int> _timeAction = {
    "update user": _estimatedTime,
    "update imam": _estimatedTime,
    "update gereja": _estimatedTime,
    "add imam": _estimatedTime,
    "add gereja": _estimatedTime,
    "add aturan pelayanan": _estimatedTime,
  };

  @override
  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "update user":
        return _updateUser(data.task.data, sender);
      case "update imam":
        return _updateImam(data.task.data, sender);
      case "update gereja":
        return _updateGereja(data.task.data, sender);
      case "add imam":
        return _addImam(data.task.data, sender);
      case "add gereja":
        return _addGereja(data.task.data, sender);
      case "add aturan pelayanan":
        return _addAturanPelayanan(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> _updateUser(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);

    var update = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> _updateImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var update = await imamCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));
    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> _updateGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var update = await gerejaCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> _addImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var configJson = modelDB.imam(data[0], data[1], data[2], data[3], "", "", 0,
        data[4], 1, 1, 1, 1, DateTime.now(), DateTime.now(), data[5], data[5]);

    var addImam = await imamCollection.insertOne(configJson);

    if (addImam.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> _addGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var configJson = modelDB.Gereja(
        data[0],
        data[1],
        data[2],
        data[3],
        data[4],
        data[5],
        data[6],
        0,
        "",
        DateTime.now(),
        data[7],
        DateTime.now(),
        data[7]);

    var addGereja = await gerejaCollection.insertOne(configJson);

    if (addGereja.isSuccess) {
      Message message = Message(agentName, 'Agent Pencarian', "REQUEST",
          Tasks('cari gereja terakhir', data[7]));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> _addAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);

    var configJson = modelDB.aturanPelayanan(data[1][0]["_id"], "", "", "", "",
        "", "", "", DateTime.now(), data[0], DateTime.now(), data[0]);

    var addAturan = await aturanPelayananCollection.insertOne(configJson);

    if (addAturan.isSuccess) {
      Message message = Message(agentName, 'Agent Page', "REQUEST",
          Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, 'Agent Page', "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  @override
  addEstimatedTime(String goals) {
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    agentName = "Agent Pendaftaran";
    plan = [
      Plan("update user", "REQUEST"),
      Plan("update imam", "REQUEST"),
      Plan("update gereja", "REQUEST"),
      Plan("add imam", "REQUEST"),
      Plan("add gereja", "REQUEST"),
      Plan("add aturan pelayanan", "INFORM"),
    ];
    goals = [
      Goals("update user", String, _timeAction["update user"]),
      Goals("update imam", String, _timeAction["update imam"]),
      Goals("update gereja", String, _timeAction["update gereja"]),
      Goals("add imam", String, _timeAction["add imam"]),
      Goals("add gereja", String, _timeAction["add gereja"]),
      Goals(
          "add aturan pelayanan", String, _timeAction["add aturan pelayanan"]),
    ];
  }
}
