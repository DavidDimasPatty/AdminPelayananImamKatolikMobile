import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
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

  @override
  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "update user":
        return updateUser(data.task.data, sender);
      case "update imam":
        return updateImam(data.task.data, sender);
      case "update gereja":
        return updateGereja(data.task.data, sender);
      case "add imam":
        return addImam(data.task.data, sender);
      case "add gereja":
        return addGereja(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> updateUser(dynamic data, String sender) async {
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

  Future<Message> updateImam(dynamic data, String sender) async {
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

  Future<Message> updateGereja(dynamic data, String sender) async {
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

  Future<Message> addImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var addImam = await imamCollection.insertOne({
      "email": data[0],
      "password": data[1],
      "idGereja": data[2],
      "name": data[3],
      "picture": "",
      "notelp": "",
      "statusPemberkatan": 0,
      "statusPerminyakan": 0,
      "statusTobat": 0,
      "statusPerkawinan": 0,
      "banned": 0,
      "notif": true,
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
      "updatedBy": data[5],
      "createdBy": data[5],
      "role": data[4]
    });
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

/////////////////BELOM KELARRRRE
  Future<Message> addGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var addGereja = await gerejaCollection.insertOne({
      "nama": data[0],
      "address": data[1],
      "paroki": data[2],
      "lingkungan": data[3],
      "deskripsi": data[4],
      "lat": data[5],
      "lng": data[6],
      "gambar": "",
      "banned": 0,
      "createdAt": DateTime.now(),
      "createdBy": data[7],
      "updatedAt": DateTime.now(),
      "updatedBy": data[7]
    });

    if (addGereja.isSuccess) {
      Message message = Message(agentName, 'Agent Pencarian', "REQUEST",
          Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  @override
  addEstimatedTime() {
    _estimatedTime++;
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
      Goals("update user", String, _estimatedTime),
      Goals("update imam", String, _estimatedTime),
      Goals("update gereja", String, _estimatedTime),
      Goals("add imam", String, _estimatedTime),
      Goals("add gereja", String, _estimatedTime),
      Goals("add aturan pelayanan", String, _estimatedTime),
    ];
  }
}
